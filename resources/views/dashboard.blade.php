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
                <a href="/" class="text-2xl font-black tracking-tight hover:opacity-90 transition-opacity">AVIAJ</a>
                <span class="text-xs tracking-wider font-bold bg-brand-800 text-brand-200 px-3 py-1 rounded-full uppercase">Corporate Portal</span>
            </div>
            
            <!-- Dynamic Role Toggle Switch -->
            <form action="{{ route('dashboard.toggle-role') }}" method="POST" class="mr-4">
                @csrf
                <button type="submit" class="flex items-center space-x-2 bg-brand-900/90 hover:bg-brand-800 px-4 py-2.5 rounded-xl border border-brand-800 transition-all text-xs font-bold tracking-wider shadow-sm active:scale-98">
                    <span class="text-brand-300 font-medium">Mode:</span>
                    <span class="px-2 py-0.5 rounded text-[10px] uppercase font-black tracking-widest bg-[#59BABA] text-brand-950 shadow-inner">
                        {{ $user->role === 'manager' ? 'Manager View' : 'Employee View' }}
                    </span>
                </button>
            </form>

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
            @if($user->role === 'manager')
                <!-- Stat 1: Pending Approvals -->
                <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-brand-100 text-brand-900 rounded-2xl">
                        <svg class="w-6 h-6 text-brand-800" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Pending Team Requests</p>
                        <h3 class="text-2xl font-black text-brand-950 mt-1">{{ $pendingTeamTrips->count() + $pendingTeamExpenses->count() }}</h3>
                    </div>
                </div>

                <!-- Stat 2: Team Approved Spent -->
                <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-indigo-100 text-indigo-700 rounded-2xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Team Approved Spent</p>
                        <h3 class="text-2xl font-black text-brand-950 mt-1">${{ number_format($teamApprovedTotal, 2) }}</h3>
                    </div>
                </div>

                <!-- Stat 3: Policy Violations -->
                <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-red-50 text-red-700 rounded-2xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Policy Exceptions</p>
                        <h3 class="text-2xl font-black text-red-600 mt-1">{{ $policyViolationsCount }}</h3>
                    </div>
                </div>

                <!-- Stat 4: Manager Status -->
                <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-emerald-100 text-emerald-800 rounded-2xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-brand-500 uppercase tracking-wider">Manager Access</p>
                        <h3 class="text-sm font-black text-emerald-800 mt-1">Policy Enforcement ON</h3>
                    </div>
                </div>
            @else
                <!-- Original Employee Stats -->
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
            @endif
        </div>

        <div class="grid lg:grid-cols-12 gap-8">
            <!-- Left Area: Active Management Tabs & Bookings (8 Cols) -->
            <div class="lg:col-span-8 space-y-8">
                <!-- Navigation Tabs -->
                <div class="bg-white p-2 rounded-2xl border border-brand-200/50 shadow-sm flex space-x-2">
                    <button @click="activeTab = 'travel'" :class="activeTab === 'travel' ? 'bg-brand-950 text-white' : 'text-brand-700 hover:bg-brand-50'" class="flex-1 py-3 px-4 rounded-xl font-bold transition-all">
                        @if($user->role === 'manager') Team Travel Approvals @else Corporate Travel @endif
                    </button>
                    <button @click="activeTab = 'expenses'" :class="activeTab === 'expenses' ? 'bg-brand-950 text-white' : 'text-brand-700 hover:bg-brand-50'" class="flex-1 py-3 px-4 rounded-xl font-bold transition-all">
                        @if($user->role === 'manager') Team Expense Claims @else Expenses Ledger @endif
                    </button>
                </div>

                <!-- Tab content: Travel & Mock Booking Engine -->
                <div x-show="activeTab === 'travel'" class="space-y-6">
                    @if($user->role === 'manager')
                        <!-- Manager Travel approvals Queue -->
                        <div class="space-y-4">
                            <div class="flex justify-between items-center mb-2">
                                <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Pending Team Travel Approvals</h2>
                                <span class="bg-brand-100 text-brand-900 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">Queue Priority</span>
                            </div>
                            
                            @forelse($pendingTeamTrips as $trip)
                            <div class="bg-white p-6 rounded-3xl border border-brand-200/50 shadow-sm flex flex-col md:flex-row justify-between gap-6 hover:shadow-md transition-shadow relative overflow-hidden">
                                @php
                                    $isOutOfPolicy = isset($trip->details['class']) && (str_contains(strtolower($trip->details['class']), 'business') || str_contains(strtolower($trip->details['class']), 'first'));
                                @endphp
                                @if($isOutOfPolicy)
                                    <div class="absolute top-0 left-0 right-0 h-1 bg-red-500"></div>
                                @endif
                                
                                <div class="flex items-start space-x-4">
                                    <img src="{{ $trip->user->avatar }}" alt="User" class="w-12 h-12 rounded-full border border-brand-200 shadow-sm object-cover mt-1">
                                    <div class="space-y-1">
                                        <div class="flex items-center space-x-2">
                                            <span class="font-bold text-brand-950 text-base">{{ $trip->user->name }}</span>
                                            <span class="text-xs text-brand-500">&bull; {{ $trip->user->email }}</span>
                                        </div>
                                        <h4 class="font-extrabold text-brand-900 text-lg leading-tight">{{ $trip->title }}</h4>
                                        <p class="text-xs text-brand-500 font-bold uppercase">{{ $trip->start_date->format('M d, Y') }}</p>
                                        
                                        <!-- Trip Breakdown -->
                                        <div class="text-xs text-brand-600 bg-brand-50 p-3 rounded-xl mt-2 grid grid-cols-2 gap-x-4 gap-y-1 border border-brand-100">
                                            @foreach($trip->details as $key => $val)
                                                <div>
                                                    <span class="font-bold text-brand-500 uppercase text-[9px]">{{ str_replace('_', ' ', $key) }}:</span>
                                                    <span class="text-brand-900">{{ $val }}</span>
                                                </div>
                                            @endforeach
                                        </div>

                                        <!-- Compliance Alert Row -->
                                        <div class="mt-3">
                                            @if($isOutOfPolicy)
                                                <div class="inline-flex items-center space-x-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-100 text-red-700 text-xs font-semibold">
                                                    <svg class="w-4 h-4 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                                                    <span>Out of Policy: Premium cabin requested (Policy cap: Economy Premium)</span>
                                                </div>
                                            @else
                                                <div class="inline-flex items-center space-x-1.5 px-3 py-1.5 rounded-xl bg-green-50 border border-green-100 text-green-700 text-xs font-semibold">
                                                    <svg class="w-4 h-4 text-green-500 flex-shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                                    <span>Within Policy bounds</span>
                                                </div>
                                            @endif
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="flex md:flex-col justify-between items-end gap-4 min-w-[160px] text-right">
                                    <div>
                                        <p class="text-xs font-bold text-brand-500 uppercase">Estimated Fare</p>
                                        <span class="text-xl font-black text-brand-950">${{ number_format($trip->price, 2) }}</span>
                                    </div>
                                    <div class="flex items-center space-x-2 w-full justify-end">
                                        <!-- Approve form -->
                                        <form action="{{ route('dashboard.approve.trip', $trip->id) }}" method="POST">
                                            @csrf
                                            <button type="submit" class="px-4 py-2 bg-brand-900 text-white hover:bg-brand-950 font-bold text-xs rounded-xl shadow-sm transition-all uppercase tracking-wide">
                                                Approve
                                            </button>
                                        </form>
                                        <!-- Reject form -->
                                        <form action="{{ route('dashboard.reject.trip', $trip->id) }}" method="POST">
                                            @csrf
                                            <button type="submit" class="px-4 py-2 bg-red-50 text-red-700 hover:bg-red-100 font-bold text-xs rounded-xl transition-all uppercase tracking-wide">
                                                Decline
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            @empty
                            <div class="text-center py-12 text-brand-500 bg-white border border-brand-200/50 rounded-3xl shadow-sm">
                                <p class="font-bold">All caught up!</p>
                                <p class="text-xs text-brand-400 mt-1">No pending team travel requests requiring your approval.</p>
                            </div>
                            @endforelse
                        </div>
                    @else
                    
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
                    @endif

                </div>

                <!-- Tab content: Expenses Claims Ledger -->
                <div x-show="activeTab === 'expenses'" class="space-y-6">
                    @if($user->role === 'manager')
                        <!-- Manager Expense Approvals Queue -->
                        <div class="space-y-4">
                            <div class="flex justify-between items-center">
                                <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Pending Team Expense Claims</h2>
                                <span class="bg-[#59BABA]/10 text-brand-950 text-xs font-black px-3 py-1 rounded-full uppercase tracking-widest">Awaiting Review</span>
                            </div>

                            <div class="bg-white rounded-3xl border border-brand-200/50 shadow-sm overflow-hidden">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-brand-50 border-b border-brand-200/50 text-brand-500 text-xs font-bold uppercase tracking-wider">
                                            <th class="p-5">Team Member</th>
                                            <th class="p-5">Merchant / Details</th>
                                            <th class="p-5">Amount</th>
                                            <th class="p-5 text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-brand-100 text-sm font-medium text-brand-900">
                                        @forelse($pendingTeamExpenses as $expense)
                                        @php
                                            $isViolation = ($expense->category === 'Meals' && $expense->amount > 150);
                                        @endphp
                                        <tr class="hover:bg-brand-50/50 transition-colors {{ $isViolation ? 'bg-red-50/20' : '' }}">
                                            <td class="p-5">
                                                <div class="flex items-center space-x-3">
                                                    <img src="{{ $expense->user->avatar }}" alt="User" class="w-8 h-8 rounded-full object-cover">
                                                    <div>
                                                        <p class="font-bold text-brand-950 leading-none">{{ $expense->user->name }}</p>
                                                        <span class="text-[10px] text-brand-500 font-bold uppercase tracking-wide">{{ $expense->date->format('M d, Y') }}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="p-5">
                                                <p class="font-bold text-brand-950">{{ $expense->merchant }}</p>
                                                <p class="text-xs text-brand-500 font-light mt-0.5">{{ $expense->description }}</p>
                                                <div class="mt-1 flex items-center space-x-2">
                                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold bg-brand-100 text-brand-800 uppercase tracking-wide">
                                                        {{ $expense->category }}
                                                    </span>
                                                    @if($isViolation)
                                                        <span class="px-2 py-0.5 rounded text-[10px] font-bold bg-red-100 text-red-700 uppercase tracking-wide flex items-center">
                                                            ✕ Daily Policy Limit Exceeded ($150 cap)
                                                        </span>
                                                    @endif
                                                </div>
                                            </td>
                                            <td class="p-5 font-black text-brand-950 text-base">${{ number_format($expense->amount, 2) }}</td>
                                            <td class="p-5 text-right">
                                                <div class="inline-flex space-x-2 justify-end">
                                                    <!-- Approve -->
                                                    <form action="{{ route('dashboard.approve.expense', $expense->id) }}" method="POST">
                                                        @csrf
                                                        <button type="submit" class="px-3.5 py-1.5 bg-brand-900 text-white hover:bg-brand-950 font-bold text-xs rounded-xl shadow-sm transition-all uppercase tracking-wide">
                                                            Approve
                                                        </button>
                                                    </form>
                                                    <!-- Reject -->
                                                    <form action="{{ route('dashboard.reject.expense', $expense->id) }}" method="POST">
                                                        @csrf
                                                        <button type="submit" class="px-3.5 py-1.5 bg-red-50 text-red-700 hover:bg-red-100 font-bold text-xs rounded-xl transition-all uppercase tracking-wide">
                                                            Reject
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                        @empty
                                        <tr>
                                            <td colspan="4" class="p-10 text-center text-brand-500 font-light bg-white">No pending expense claims in your queue.</td>
                                        </tr>
                                        @endforelse
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    @else
                        <!-- Original Employee Expenses ledger -->
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
                    @endif
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
