<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aviaj | Corporate Dashboard</title>
    
    <!-- Premium Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="font-sans text-brand-900 bg-brand-50 selection:bg-brand-200 antialiased overflow-x-hidden" x-data="{ activeTab: 'travel', showExpenseModal: false, showCardModal: false }">

    <!-- Global App Header -->
    <header class="bg-brand-950 text-white sticky top-0 z-40 shadow-md">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <div class="flex items-center space-x-6">
                <a href="/" class="flex items-center hover:opacity-90 transition-opacity">
                    <svg width="128" height="40" viewBox="0 0 128 40" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<rect width="128" height="40" fill="url(#pattern0_0_477)"/>
<defs>
<pattern id="pattern0_0_477" patternContentUnits="objectBoundingBox" width="1" height="1">
<use xlink:href="#image0_0_477" transform="scale(0.00390625 0.0125)"/>
</pattern>
<image id="image0_0_477" width="256" height="80" preserveAspectRatio="none" xlink:href="data:image/png;base64,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"/>
</defs>
</svg>
                </a>
                <span class="text-xs tracking-wider font-bold bg-brand-800 text-brand-200 px-3 py-1 rounded-full uppercase">Corporate Portal</span>
            </div>
            
            <!-- User Info Panel -->
            <div class="flex items-center space-x-4">
                <div class="text-right hidden sm:block">
                    <p class="text-sm font-bold text-white">{{ $user->name }}</p>
                    <p class="text-xs text-brand-400 capitalize">{{ $user->role }} &bull; {{ $user->company_name }}</p>
                </div>
                <img src="{{ $user->avatar }}" alt="Avatar" class="w-10 h-10 rounded-full border-2 border-brand-800 shadow-sm">
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-6 py-8 space-y-8">
        
        <!-- Live Alert Notifications -->
        @if(session('success'))
        <div class="p-4 rounded-2xl bg-emerald-100/80 border border-emerald-200 text-emerald-800 text-sm font-semibold flex items-center justify-between shadow-sm animate-pulse">
            <span>{{ session('success') }}</span>
            <button @click="$el.parentElement.remove()" class="text-emerald-950 font-bold ml-4">✕</button>
        </div>
        @endif

        <!-- Quick Summary Stats Card Grid -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
            <!-- Stat 1 -->
            <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                <div class="p-3 bg-brand-100 text-brand-800 rounded-2xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9-2-9-18-9 18 9-2zm0 0v-8"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Active Bookings</p>
                    <h3 class="text-2xl font-black text-brand-950 mt-1">{{ $totalTripsCount }}</h3>
                </div>
            </div>

            <!-- Stat 2 -->
            <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                <div class="p-3 bg-indigo-100 text-indigo-700 rounded-2xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 14l2 2 4-4m-6 2h.01M12 20h.01M15 20h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Approved Spent</p>
                    <h3 class="text-2xl font-black text-brand-950 mt-1">${{ number_format($totalSpent, 2) }}</h3>
                </div>
            </div>

            <!-- Stat 3 -->
            <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                <div class="p-3 bg-violet-100 text-violet-700 rounded-2xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Active Card Spent</p>
                    <h3 class="text-2xl font-black text-brand-950 mt-1">${{ number_format($activeCardSpent, 2) }}</h3>
                </div>
            </div>

            <!-- Stat 4 -->
            <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                <div class="p-3 bg-emerald-100 text-emerald-700 rounded-2xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Available Card Limit</p>
                    <h3 class="text-2xl font-black text-brand-950 mt-1">${{ number_format($availableLimit, 2) }}</h3>
                </div>
            </div>
        </div>

        <div class="grid lg:grid-cols-12 gap-8">
            <!-- Left Area: Active Management Tabs & Bookings (8 Cols) -->
            <div class="lg:col-span-8 space-y-8">
                <!-- Navigation Tabs -->
                <div class="bg-white p-2 rounded-2xl border border-brand-200/50 shadow-sm flex space-x-2">
                    <button @click="activeTab = 'travel'" :class="activeTab === 'travel' ? 'bg-brand-950 text-white' : 'text-brand-700 hover:bg-brand-50'" class="flex-1 py-3 px-4 rounded-xl font-bold transition-all">
                        Corporate Travel
                    </button>
                    <button @click="activeTab = 'expenses'" :class="activeTab === 'expenses' ? 'bg-brand-950 text-white' : 'text-brand-700 hover:bg-brand-50'" class="flex-1 py-3 px-4 rounded-xl font-bold transition-all">
                        Expenses Ledger
                    </button>
                </div>

                <!-- Tab content: Travel & Mock Booking Engine -->
                <div x-show="activeTab === 'travel'" class="space-y-6">
                    
                    <!-- Quick Travel Booking Form -->
                    <div class="bg-white p-8 rounded-3xl border border-brand-200/50 shadow-sm space-y-6">
                        <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Book New Travel</h2>
                        
                        <form action="{{ route('dashboard.book') }}" method="POST" class="grid sm:grid-cols-3 gap-6">
                            @csrf
                            <div>
                                <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Service Type</label>
                                <select name="type" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                                    <option value="flight">Flight Segment</option>
                                    <option value="hotel">Stay / Hotel</option>
                                    <option value="car">Car Rental (EV/SUV)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Destination / Vendor</label>
                                <input type="text" name="title" required placeholder="e.g. San Francisco (SFO)" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 placeholder:text-brand-400 focus:outline-none focus:ring-2 focus:ring-brand-500">
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Estimated Cost ($)</label>
                                <input type="number" name="price" required min="1" placeholder="450" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 placeholder:text-brand-400 focus:outline-none focus:ring-2 focus:ring-brand-500">
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Start Date</label>
                                <input type="date" name="start_date" required class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                            </div>
                            <div class="flex items-end">
                                <button type="submit" class="w-full py-3 bg-brand-950 text-white font-bold rounded-xl shadow-lg shadow-brand-950/15 hover:bg-brand-900 active:scale-98 transition-all">
                                    Confirm Booking
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Booked Trips List -->
                    <div class="space-y-4">
                        <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Active Itineraries</h2>
                        
                        @forelse($trips as $trip)
                        <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex flex-col sm:flex-row justify-between gap-6 hover:shadow-md transition-shadow">
                            <div class="flex items-start space-x-4">
                                <div class="p-3 rounded-2xl bg-brand-50 text-brand-950">
                                    @if($trip->type === 'flight')
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9-2-9-18-9 18 9-2zm0 0v-8"/></svg>
                                    @elseif($trip->type === 'hotel')
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                                    @else
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H8.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"/></svg>
                                    @endif
                                </div>
                                <div class="space-y-1">
                                    <h4 class="font-extrabold text-brand-950 text-lg leading-tight">{{ $trip->title }}</h4>
                                    <p class="text-xs text-brand-500 font-bold uppercase">{{ $trip->start_date->format('M d, Y') }}</p>
                                    
                                    <!-- Trip Details JSON view -->
                                    <div class="text-xs text-brand-600 bg-brand-50 p-3 rounded-xl mt-2 grid grid-cols-2 gap-x-4 gap-y-1">
                                        @foreach($trip->details as $key => $val)
                                            <div>
                                                <span class="font-bold text-brand-500 uppercase text-[10px]">{{ str_replace('_', ' ', $key) }}:</span>
                                                <span class="text-brand-900">{{ $val }}</span>
                                            </div>
                                        @endforeach
                                    </div>
                                </div>
                            </div>
                            <div class="text-right flex flex-col justify-between items-end">
                                <span class="text-lg font-black text-brand-950">${{ number_format($trip->price, 2) }}</span>
                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700 uppercase tracking-wide">Confirmed</span>
                            </div>
                        </div>
                        @empty
                        <p class="text-center py-12 text-brand-500 bg-white border border-brand-200/50 rounded-3xl">No corporate itineraries booked yet.</p>
                        @endforelse
                    </div>

                </div>

                <!-- Tab content: Expenses Claims Ledger -->
                <div x-show="activeTab === 'expenses'" class="space-y-6">
                    <div class="flex justify-between items-center">
                        <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Expense Requests</h2>
                        <button @click="showExpenseModal = true" class="px-5 py-2.5 bg-brand-950 text-white font-bold text-sm rounded-xl hover:bg-brand-900 active:scale-98 transition-all">
                            Submit Expense Claim
                        </button>
                    </div>

                    <div class="bg-white rounded-3xl border border-brand-200/50 shadow-sm overflow-hidden">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-brand-50 border-b border-brand-200/50 text-brand-500 text-xs font-bold uppercase tracking-wider">
                                    <th class="p-5">Merchant</th>
                                    <th class="p-5">Date</th>
                                    <th class="p-5">Category</th>
                                    <th class="p-5">Amount</th>
                                    <th class="p-5">Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-brand-100 text-sm font-medium text-brand-900">
                                @forelse($expenses as $expense)
                                <tr class="hover:bg-brand-50/50 transition-colors">
                                    <td class="p-5">
                                        <p class="font-bold text-brand-950">{{ $expense->merchant }}</p>
                                        <p class="text-xs text-brand-500 font-light mt-0.5">{{ $expense->description }}</p>
                                    </td>
                                    <td class="p-5 text-brand-600">{{ $expense->date->format('M d, Y') }}</td>
                                    <td class="p-5">
                                        <span class="px-2.5 py-1 rounded-lg text-xs font-semibold bg-brand-100 text-brand-800 uppercase tracking-wide">
                                            {{ $expense->category }}
                                        </span>
                                    </td>
                                    <td class="p-5 font-black text-brand-950">${{ number_format($expense->amount, 2) }}</td>
                                    <td class="p-5">
                                        @if($expense->status === 'approved')
                                            <span class="px-2.5 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700 uppercase tracking-wide">Approved</span>
                                        @elseif($expense->status === 'rejected')
                                            <span class="px-2.5 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700 uppercase tracking-wide">Rejected</span>
                                        @else
                                            <span class="px-2.5 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700 uppercase tracking-wide">Pending</span>
                                        @endif
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="5" class="p-10 text-center text-brand-500 font-light">No expenses claimed yet.</td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <!-- Right Area: Virtual Cards List & Controls (4 Cols) -->
            <div class="lg:col-span-4 space-y-6">
                <div class="flex justify-between items-center">
                    <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Virtual Cards</h2>
                    <button @click="showCardModal = true" class="text-xs font-bold uppercase tracking-wider text-indigo-600 hover:text-indigo-800">
                        + Issue Card
                    </button>
                </div>

                <!-- Display active/inactive virtual cards -->
                <div class="space-y-6">
                    @forelse($cards as $card)
                    <div class="relative group">
                        <!-- Premium CSS Card mockup with glass effects -->
                        <div :class="'{{ $card->status }}' === 'paused' ? 'opacity-60 saturate-50' : ''" class="bg-gradient-to-br from-brand-900 to-indigo-950 text-white p-6 rounded-2xl shadow-xl relative overflow-hidden transition-all duration-300">
                            <!-- Premium overlay glow -->
                            <div class="absolute -right-10 -bottom-10 w-40 h-40 bg-indigo-500/10 rounded-full filter blur-xl"></div>
                            
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-[10px] text-brand-300 font-bold uppercase tracking-wider">{{ $card->card_type }} virtual</p>
                                    <h3 class="text-lg font-bold tracking-wide mt-1">{{ $card->cardholder_name }}</h3>
                                </div>
                                <div class="text-xl font-black italic tracking-tighter">{{ $card->card_type }}</div>
                            </div>
                            <div class="mt-8">
                                <p class="text-lg font-mono tracking-widest">{{ $card->card_number }}</p>
                            </div>
                            <div class="mt-4 flex justify-between items-end">
                                <div>
                                    <p class="text-[9px] text-brand-400 uppercase tracking-widest">Spent / Limit</p>
                                    <p class="text-xs font-semibold">${{ number_format($card->spent_amount, 2) }} / ${{ number_format($card->limit_amount, 2) }}</p>
                                </div>
                                <div class="text-right">
                                    <p class="text-[9px] text-brand-400 uppercase tracking-widest">Expires</p>
                                    <p class="text-xs font-semibold">{{ $card->expiry_date }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Hover Card Action Overlay -->
                        <div class="absolute inset-0 bg-brand-950/80 rounded-2xl flex items-center justify-center space-x-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                            <form action="{{ route('dashboard.card.toggle', $card->id) }}" method="POST">
                                @csrf
                                <button type="submit" class="px-4 py-2 bg-white text-brand-950 rounded-xl font-bold text-xs hover:bg-brand-100 transition-colors uppercase tracking-wider">
                                    {{ $card->status === 'active' ? 'Pause' : 'Activate' }}
                                </button>
                            </form>
                            <span class="px-3 py-1.5 rounded-lg border border-white/20 text-white font-bold text-[10px] uppercase tracking-wider">
                                CVV: {{ $card->cvv }}
                            </span>
                        </div>
                    </div>
                    @empty
                    <p class="text-center py-8 text-brand-500 bg-white border border-brand-200/50 rounded-3xl">No virtual cards issued.</p>
                    @endforelse
                </div>
            </div>
        </div>

    </main>

    <!-- Modal 1: Submit Expense Claim -->
    <div x-show="showExpenseModal" class="fixed inset-0 bg-brand-950/50 backdrop-blur-sm flex items-center justify-center z-50 p-6" x-transition>
        <div class="bg-white p-8 rounded-3xl border border-brand-200 shadow-2xl max-w-lg w-full space-y-6" @click.away="showExpenseModal = false">
            <div class="flex justify-between items-center">
                <h3 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Submit Expense Receipt</h3>
                <button @click="showExpenseModal = false" class="text-brand-500 font-bold hover:text-brand-950">✕</button>
            </div>
            
            <form action="{{ route('dashboard.expense') }}" method="POST" class="space-y-4">
                @csrf
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Merchant Name</label>
                    <input type="text" name="merchant" required placeholder="e.g. AWS Cloud Services" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Amount ($)</label>
                        <input type="number" step="0.01" name="amount" required placeholder="42.50" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Category</label>
                        <select name="category" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                            <option value="Travel">Travel</option>
                            <option value="Meals">Meals</option>
                            <option value="Lodging">Lodging</option>
                            <option value="Software">Software</option>
                            <option value="Hardware">Hardware</option>
                        </select>
                    </div>
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Date</label>
                    <input type="date" name="date" required class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Description</label>
                    <textarea name="description" placeholder="Specify ride itinerary or project relevance..." rows="3" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500"></textarea>
                </div>
                <button type="submit" class="w-full py-4 bg-brand-950 text-white font-bold rounded-xl shadow-lg shadow-brand-950/15 hover:bg-brand-900 active:scale-98 transition-all">
                    Submit Claims Receipt
                </button>
            </form>
        </div>
    </div>

    <!-- Modal 2: Issue Virtual Card -->
    <div x-show="showCardModal" class="fixed inset-0 bg-brand-950/50 backdrop-blur-sm flex items-center justify-center z-50 p-6" x-transition>
        <div class="bg-white p-8 rounded-3xl border border-brand-200 shadow-2xl max-w-lg w-full space-y-6" @click.away="showCardModal = false">
            <div class="flex justify-between items-center">
                <h3 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Issue Virtual Card</h3>
                <button @click="showCardModal = false" class="text-brand-500 font-bold hover:text-brand-950">✕</button>
            </div>
            
            <form action="{{ route('dashboard.card') }}" method="POST" class="space-y-4">
                @csrf
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Cardholder Name</label>
                    <input type="text" name="cardholder_name" required value="{{ $user->name }}" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Spend Limit ($)</label>
                    <input type="number" name="limit_amount" required min="10" placeholder="5000" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase text-brand-500 mb-2">Card Brand</label>
                    <select name="card_type" class="w-full p-3 rounded-xl border border-brand-200 bg-brand-50 font-medium text-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500">
                        <option value="Visa">Visa Card</option>
                        <option value="Mastercard">Mastercard</option>
                    </select>
                </div>
                <button type="submit" class="w-full py-4 bg-brand-950 text-white font-bold rounded-xl shadow-lg shadow-brand-950/15 hover:bg-brand-900 active:scale-98 transition-all">
                    Issue Instant Card
                </button>
            </form>
        </div>
    </div>

</body>
</html>
