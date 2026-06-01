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
                'role' => 'manager',
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

        // Seed Team Members Marcus and Elena under same Company
        $marcus = User::where('email', 'marcus@aviaj.com')->first();
        if (!$marcus) {
            $marcus = User::create([
                'name' => 'Marcus Vance',
                'email' => 'marcus@aviaj.com',
                'password' => Hash::make('password'),
                'role' => 'manager',
                'company_name' => 'Acme Corp',
                'phone' => '+1 (555) 012-3456',
                'avatar' => 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150',
            ]);

            Trip::create([
                'user_id' => $marcus->id,
                'type' => 'flight',
                'title' => 'Flight to Chicago (ORD)',
                'details' => [
                    'airline' => 'United Airlines',
                    'flight_number' => 'UA 891',
                    'class' => 'Economy Premium',
                    'departure' => 'San Francisco (SFO) - 01:15 PM',
                    'arrival' => 'Chicago (ORD) - 07:30 PM',
                ],
                'start_date' => now()->addDays(12)->toDateString(),
                'price' => 450.00,
                'status' => 'pending',
            ]);

            Expense::create([
                'user_id' => $marcus->id,
                'merchant' => 'Hertz Car Rental',
                'amount' => 120.50,
                'category' => 'Travel',
                'date' => now()->subDays(3)->toDateString(),
                'status' => 'pending',
                'description' => 'Corporate discount EV rental for client meeting',
            ]);
        }

        $elena = User::where('email', 'elena@aviaj.com')->first();
        if (!$elena) {
            $elena = User::create([
                'name' => 'Elena Rostova',
                'email' => 'elena@aviaj.com',
                'password' => Hash::make('password'),
                'role' => 'manager',
                'company_name' => 'Acme Corp',
                'phone' => '+1 (555) 018-9901',
                'avatar' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150',
            ]);

            Trip::create([
                'user_id' => $elena->id,
                'type' => 'flight',
                'title' => 'Flight to London (LHR)',
                'details' => [
                    'airline' => 'British Airways',
                    'flight_number' => 'BA 286',
                    'class' => 'First Class',
                    'departure' => 'San Francisco (SFO) - 06:45 PM',
                    'arrival' => 'London (LHR) - 01:00 PM',
                ],
                'start_date' => now()->addDays(20)->toDateString(),
                'price' => 3200.00,
                'status' => 'pending',
            ]);

            Expense::create([
                'user_id' => $elena->id,
                'merchant' => 'The French Laundry',
                'amount' => 850.00,
                'category' => 'Meals',
                'date' => now()->subDays(1)->toDateString(),
                'status' => 'pending',
                'description' => 'Client appreciation dinner',
            ]);
        }

        return $user;
    }

    public function index()
    {
        $user = $this->getOrCreateDemoUser();
        // Force manager role by default so Figma design is visible immediately
        if ($user->email === 'demo@aviaj.com' && $user->role !== 'manager') {
            $user->role = 'manager';
            $user->save();
        }
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

        // Fetch Manager Approvals if Role is manager
        $pendingTeamTrips = collect();
        $pendingTeamExpenses = collect();
        $teamApprovedTotal = 0;
        $policyViolationsCount = 0;

        if ($user->role === 'manager') {
            // Find all pending trips from other employees
            $pendingTeamTrips = Trip::where('status', 'pending')
                ->where('user_id', '!=', $user->id)
                ->with('user')
                ->get();

            // Find all pending expenses from other employees
            $pendingTeamExpenses = Expense::where('status', 'pending')
                ->where('user_id', '!=', $user->id)
                ->with('user')
                ->get();

            // Monthly team spend calculation (approved team expenses)
            $teamApprovedTotal = Expense::where('status', 'approved')
                ->where('user_id', '!=', $user->id)
                ->sum('amount');

            // Count items breaking policy constraints
            foreach ($pendingTeamTrips as $t) {
                if (isset($t->details['class']) && str_contains(strtolower($t->details['class']), 'business') || str_contains(strtolower($t->details['class']), 'first')) {
                    $policyViolationsCount++;
                }
            }
            foreach ($pendingTeamExpenses as $e) {
                if ($e->category === 'Meals' && $e->amount > 150) {
                    $policyViolationsCount++;
                }
            }
        }

        return view('dashboard', compact(
            'user', 'trips', 'expenses', 'cards', 
            'totalTripsCount', 'totalSpent', 'availableLimit', 'activeCardSpent',
            'pendingTeamTrips', 'pendingTeamExpenses', 'teamApprovedTotal', 'policyViolationsCount'
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

        return redirect()->route('dashboard')->with('success', 'Trip booked successfully through Aviaj corporate travel!');
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


    public function toggleRole()
    {
        $user = Auth::user() ?? $this->getOrCreateDemoUser();
        $user->role = $user->role === 'manager' ? 'employee' : 'manager';
        $user->save();

        return redirect()->route('dashboard')->with('success', "Switched role view to " . strtoupper($user->role) . " mode!");
    }

    public function approveTrip($id)
    {
        $trip = Trip::findOrFail($id);
        $trip->status = 'confirmed';
        $trip->save();

        return redirect()->route('dashboard')->with('success', "Travel request for " . $trip->user->name . " was successfully APPROVED!");
    }

    public function rejectTrip($id)
    {
        $trip = Trip::findOrFail($id);
        $trip->status = 'rejected';
        $trip->save();

        return redirect()->route('dashboard')->with('success', "Travel request for " . $trip->user->name . " has been DECLINED.");
    }

    public function approveExpense($id)
    {
        $expense = Expense::findOrFail($id);
        $expense->status = 'approved';
        $expense->save();

        return redirect()->route('dashboard')->with('success', "Expense claim for $" . number_format($expense->amount, 2) . " from " . $expense->user->name . " was APPROVED.");
    }

    public function rejectExpense($id)
    {
        $expense = Expense::findOrFail($id);
        $expense->status = 'rejected';
        $expense->save();

        return redirect()->route('dashboard')->with('success', "Expense claim from " . $expense->user->name . " has been REJECTED.");
    }

    public function searchFlights(Request $request)
    {
        $from = $request->input("from", "San Francisco (SFO)");
        $to = $request->input("to", "London (LHR)");
        $dates = $request->input("dates", "Oct 24 - Oct 28");
        $travelers = $request->input("travelers", "1 Adult, Economy");

        return view("search-results", compact("from", "to", "dates", "travelers"));
    }

    public function submitEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $email = $request->input('email');
        
        $subject = "Aviaj - New Account Registration";
        $message = "Hi, <br><br>Thank you for getting started with Aviaj. A new account registration request has been received for email: <strong>" . htmlspecialchars($email) . "</strong>.<br><br>Best regards,<br>Aviaj Team";

        $mailFile = '/home4/ajathufs/ajath.co.in/mail/class.phpmailer.php';
        if (file_exists($mailFile)) {
            try {
                require_once($mailFile);
                $mail = new \PHPMailer();
                $mail->CharSet = "utf-8";
                $mail->IsSMTP();
                $mail->SMTPAuth = true;
                $mail->Username = "info@aviaj.com";
                $mail->Password = "P@sssw0rd1111";
                $mail->SMTPSecure = "ssl";  
                $mail->Host = "ajath.com";
                $mail->Port = "465";
                
                $mail->setFrom('info@aviaj.com', 'Aviaj');
                $mail->AddAddress('manjot@ajath.com', 'Manjot');
                $mail->AddAddress('shachisheh@gmail.com', 'Shachish');
                
                // Also add the registered email so they get the confirmation
                $mail->AddAddress($email);
                
                $mail->Subject = $subject;
                $mail->IsHTML(true);
                $mail->Body = $message;
                
                $mail->Send();
            } catch (\Exception $e) {
                \Log::error("Mail exception: " . $e->getMessage());
            }
        } else {
            \Log::error("PHPMailer file not found at " . $mailFile);
        }

        $user = $this->getOrCreateDemoUser();
        \Auth::login($user);
        return redirect()->route('dashboard')->with('success', 'Account registered and confirmation email sent!');
    }


    public function expenseManagement()
    {
        return view("expense-management");
    }
}
