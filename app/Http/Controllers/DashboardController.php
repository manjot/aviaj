<?php

namespace App\Http\Controllers;

use App\Models\Trip;
use App\Models\Expense;
use App\Models\CorporateCard;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class DashboardController extends Controller
{
    private function getOrCreateDemoUser()
    {
        $user = User::where('email', 'demo@aviaj.com')->first();
        
        if (!$user) {
            $user = User::create([
                'name' => 'Sarah Jenkins',
                'email' => 'demo@aviaj.com',
                'password' => Hash::make('password'),
                'role' => 'employee',
                'company_name' => 'Acme Corp',
                'phone' => '+1 (555) 019-2834',
                'avatar' => 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
            ]);

            // Create some default virtual cards
            CorporateCard::create([
                'user_id' => $user->id,
                'card_number' => '•••• •••• •••• 8824',
                'cardholder_name' => 'Sarah Jenkins',
                'expiry_date' => '08/30',
                'cvv' => '342',
                'card_type' => 'Visa',
                'limit_amount' => 5000.00,
                'spent_amount' => 1240.50,
                'status' => 'active',
            ]);

            CorporateCard::create([
                'user_id' => $user->id,
                'card_number' => '•••• •••• •••• 4192',
                'cardholder_name' => 'Acme Corp Travel',
                'expiry_date' => '12/28',
                'cvv' => '901',
                'card_type' => 'Mastercard',
                'limit_amount' => 15000.00,
                'spent_amount' => 4500.00,
                'status' => 'active',
            ]);

            // Create some default trips
            Trip::create([
                'user_id' => $user->id,
                'type' => 'flight',
                'title' => 'Flight to San Francisco (SFO)',
                'details' => [
                    'airline' => 'United Airlines',
                    'flight_number' => 'UA 2402',
                    'class' => 'Business',
                    'departure' => 'New York (JFK) - 08:30 AM',
                    'arrival' => 'San Francisco (SFO) - 11:45 AM',
                ],
                'start_date' => now()->addDays(5)->toDateString(),
                'price' => 650.00,
                'status' => 'confirmed',
            ]);

            Trip::create([
                'user_id' => $user->id,
                'type' => 'hotel',
                'title' => 'The Ritz-Carlton, SFO',
                'details' => [
                    'hotel_name' => 'The Ritz-Carlton',
                    'room_type' => 'Deluxe King',
                    'address' => '600 Stockton St, San Francisco, CA 94108',
                    'nights' => '3 Nights',
                ],
                'start_date' => now()->addDays(5)->toDateString(),
                'end_date' => now()->addDays(8)->toDateString(),
                'price' => 1200.00,
                'status' => 'confirmed',
            ]);

            // Create some default expenses
            Expense::create([
                'user_id' => $user->id,
                'merchant' => 'Uber Inc',
                'amount' => 42.50,
                'category' => 'Travel',
                'date' => now()->subDays(2)->toDateString(),
                'status' => 'approved',
                'description' => 'Ride from office to airport',
            ]);

            Expense::create([
                'user_id' => $user->id,
                'merchant' => 'Starbucks Coffee',
                'amount' => 14.20,
                'category' => 'Meals',
                'date' => now()->subDays(2)->toDateString(),
                'status' => 'approved',
                'description' => 'Team coffee meeting',
            ]);

            Expense::create([
                'user_id' => $user->id,
                'merchant' => 'AWS Cloud Services',
                'amount' => 389.00,
                'category' => 'Software',
                'date' => now()->subDays(1)->toDateString(),
                'status' => 'pending',
                'description' => 'Dev server hosting for scaling mockups',
            ]);
        }

        return $user;
    }

    public function index()
    {
        $user = $this->getOrCreateDemoUser();
        Auth::login($user);

        $trips = Trip::where('user_id', $user->id)->orderBy('start_date', 'asc')->get();
        $expenses = Expense::where('user_id', $user->id)->orderBy('date', 'desc')->get();
        $cards = CorporateCard::where('user_id', $user->id)->get();

        // Calculate aggregated metrics
        $totalTripsCount = $trips->count();
        $totalSpent = $expenses->where('status', 'approved')->sum('amount');
        $activeCardLimit = $cards->where('status', 'active')->sum('limit_amount');
        $activeCardSpent = $cards->where('status', 'active')->sum('spent_amount');
        $availableLimit = max(0, $activeCardLimit - $activeCardSpent);

        return view('dashboard', compact(
            'user', 'trips', 'expenses', 'cards', 
            'totalTripsCount', 'totalSpent', 'availableLimit', 'activeCardSpent'
        ));
    }

    public function bookTravel(Request $request)
    {
        $request->validate([
            'type' => 'required|in:flight,hotel,car',
            'title' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'start_date' => 'required|date',
        ]);

        $user = Auth::user() ?? $this->getOrCreateDemoUser();

        $details = [];
        if ($request->type === 'flight') {
            $details = [
                'airline' => 'SkyBound Air',
                'flight_number' => 'SB-' . rand(1000, 9999),
                'class' => 'Economy Premium',
                'departure' => 'Chicago (ORD) - 02:00 PM',
                'arrival' => $request->title,
            ];
        } elseif ($request->type === 'hotel') {
            $details = [
                'hotel_name' => $request->title,
                'room_type' => 'Executive Suite',
                'address' => 'Corporate Plaza Center',
                'nights' => '2 Nights',
            ];
        } else {
            $details = [
                'provider' => 'Hertz Corporate',
                'car_type' => 'Tesla Model Y (EV)',
                'pickup' => 'Airport Station',
            ];
        }

        Trip::create([
            'user_id' => $user->id,
            'type' => $request->type,
            'title' => $request->title,
            'details' => $details,
            'start_date' => $request->start_date,
            'price' => $request->price,
            'status' => 'confirmed',
        ]);

        return redirect()->route('dashboard')->with('success', 'Trip booked successfully through Navan corporate travel!');
    }

    public function addExpense(Request $request)
    {
        $request->validate([
            'merchant' => 'required|string|max:255',
            'amount' => 'required|numeric|min:0.1',
            'category' => 'required|string|max:100',
            'date' => 'required|date',
            'description' => 'nullable|string',
        ]);

        $user = Auth::user() ?? $this->getOrCreateDemoUser();

        Expense::create([
            'user_id' => $user->id,
            'merchant' => $request->merchant,
            'amount' => $request->amount,
            'category' => $request->category,
            'date' => $request->date,
            'status' => 'pending',
            'description' => $request->description,
        ]);

        return redirect()->route('dashboard')->with('success', 'Expense claim submitted for approval!');
    }

    public function createCard(Request $request)
    {
        $request->validate([
            'cardholder_name' => 'required|string|max:255',
            'limit_amount' => 'required|numeric|min:10',
            'card_type' => 'required|in:Visa,Mastercard',
        ]);

        $user = Auth::user() ?? $this->getOrCreateDemoUser();

        $lastFour = rand(1000, 9999);

        CorporateCard::create([
            'user_id' => $user->id,
            'card_number' => "•••• •••• •••• {$lastFour}",
            'cardholder_name' => $request->cardholder_name,
            'expiry_date' => '05/31',
            'cvv' => (string)rand(100, 999),
            'card_type' => $request->card_type,
            'limit_amount' => $request->limit_amount,
            'spent_amount' => 0.00,
            'status' => 'active',
        ]);

        return redirect()->route('dashboard')->with('success', 'Virtual corporate card issued successfully!');
    }

    public function toggleCardStatus($id)
    {
        $card = CorporateCard::findOrFail($id);
        
        $card->status = $card->status === 'active' ? 'paused' : 'active';
        $card->save();

        return redirect()->route('dashboard')->with('success', 'Card status updated successfully.');
    }

    public function demoLogin()
    {
        $user = $this->getOrCreateDemoUser();
        Auth::login($user);
        return redirect()->route('dashboard');
    }
}
