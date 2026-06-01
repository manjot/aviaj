<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aviaj | Corporate Portal</title>
    
    <!-- Premium Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="font-sans text-brand-900 bg-[#FAF8FF] selection:bg-[#59BABA]/30 antialiased overflow-x-hidden" x-data="{ activeTab: 'travel', showExpenseModal: false, showCardModal: false }">

    @if($user->role === 'manager')
        <!-- ================= FIGMA 3-COLUMN APPROVAL HUB (MANAGER MODE) ================= -->
        <div class="min-h-screen flex flex-col md:flex-row bg-[#FAF8FF]">
            
            <!-- LEFT COLUMN: Corporate Hub Sidebar (256px / w-64) -->
            <aside class="w-full md:w-64 bg-white border-r border-slate-100 flex flex-col justify-between p-6 flex-shrink-0">
                <div class="space-y-8">
                    <!-- Brand Identity & Switcher -->
                    <div class="flex flex-col space-y-3">
                        <div class="flex items-center space-x-3">
                            <div class="w-8 h-8 rounded-lg bg-[#59BABA] flex items-center justify-center text-white font-black text-sm shadow-md">A</div>
                            <div>
                                <h1 class="text-lg font-black tracking-tight text-slate-900 font-outfit uppercase">AVIAJ</h1>
                                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Approval Hub</p>
                            </div>
                        </div>
                        
                        <!-- Role View Switcher -->
                        <form action="{{ route('dashboard.toggle-role') }}" method="POST">
                            @csrf
                            <button type="submit" class="w-full flex items-center justify-between bg-slate-50 hover:bg-[#59BABA]/5 px-3 py-2 rounded-xl border border-slate-100 transition-all text-xs font-bold text-slate-700 shadow-sm active:scale-98">
                                <span class="text-slate-400 font-medium">Mode:</span>
                                <span class="px-2 py-0.5 rounded text-[9px] uppercase font-black tracking-wider bg-[#59BABA] text-brand-950 shadow-sm">
                                    Manager View
                                </span>
                            </button>
                        </form>
                    </div>

                    <!-- Sidebar Navigation Menu -->
                    <nav class="space-y-1">
                        <a href="#" class="flex items-center space-x-3 px-3 py-2.5 rounded-xl text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-semibold text-sm transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z"/></svg>
                            <span>Dashboard</span>
                        </a>
                        <a href="#" class="flex items-center space-x-3 px-3 py-2.5 rounded-xl bg-[#E6F8F6] text-[#0F5B54] font-bold text-sm transition-colors border-l-4 border-[#59BABA]">
                            <svg class="w-5 h-5 text-[#59BABA]" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                            <span>Pending Approvals</span>
                        </a>
                        <a href="#" class="flex items-center space-x-3 px-3 py-2.5 rounded-xl text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-semibold text-sm transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            <span>History</span>
                        </a>
                        <a href="#" class="flex items-center space-x-3 px-3 py-2.5 rounded-xl text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-semibold text-sm transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                            <span>Policy Engine</span>
                        </a>
                        <a href="#" class="flex items-center space-x-3 px-3 py-2.5 rounded-xl text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-semibold text-sm transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                            <span>Settings</span>
                        </a>
                    </nav>
                </div>

                <!-- Sidebar Footer Operations -->
                <div class="space-y-4 pt-6 border-t border-slate-100">
                    <button class="w-full py-2.5 px-4 bg-[#0F5B54] text-white hover:bg-[#0c4a44] font-bold text-xs rounded-xl shadow-md transition-colors uppercase tracking-wider">
                        Policy Overview
                    </button>
                    
                    <div class="space-y-2 text-xs font-semibold text-slate-500">
                        <a href="#" class="flex items-center space-x-2 px-3 py-1.5 hover:text-slate-900 transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                            <span>Support</span>
                        </a>
                        <a href="/" class="flex items-center space-x-2 px-3 py-1.5 hover:text-red-600 transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                            <span>Sign Out</span>
                        </a>
                    </div>
                    
                    <p class="text-[9px] text-slate-400 font-medium leading-relaxed">
                        &copy; 2026 Aviaj Travel.<br>Privacy &bull; Terms &bull; Compliance
                    </p>
                </div>
            </aside>

            <!-- MIDDLE COLUMN: Main Approvals Queue & Search (Flexible) -->
            <main class="flex-1 p-8 space-y-8 overflow-y-auto max-w-4xl">
                
                <!-- Action Header Row -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-100 pb-4">
                    <div class="relative w-full max-w-md">
                        <svg class="w-5 h-5 absolute left-4 top-3.5 text-slate-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        <input type="text" placeholder="Search requests, travelers..." class="w-full pl-12 pr-4 py-3 rounded-2xl bg-white border border-slate-100 text-sm font-semibold text-slate-800 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#59BABA] transition-all shadow-sm">
                    </div>
                    
                    <div class="flex items-center space-x-4 text-xs font-bold text-slate-500">
                        <a href="#" class="hover:text-slate-900 transition-colors uppercase tracking-wider">Approvals</a>
                        <a href="#" class="hover:text-slate-900 transition-colors uppercase tracking-wider">Analytics</a>
                        <a href="#" class="hover:text-slate-900 transition-colors uppercase tracking-wider">Policy</a>
                        <a href="#" class="hover:text-slate-900 transition-colors uppercase tracking-wider">Teams</a>
                        
                        <div class="flex items-center space-x-3 pl-4 border-l border-slate-200">
                            <button class="p-1.5 hover:bg-slate-100 rounded-lg transition-colors text-slate-600 relative">
                                <span class="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-red-500"></span>
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
                            </button>
                            <img src="{{ $user->avatar }}" alt="Sarah" class="w-8 h-8 rounded-full border border-slate-200 object-cover shadow-sm">
                        </div>
                    </div>
                </div>

                <!-- Page Welcome Title -->
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h2 class="text-3xl font-extrabold text-slate-900 font-outfit leading-none">Pending Approvals</h2>
                        <p class="text-sm text-slate-400 font-semibold mt-2">Review and action outstanding travel requests.</p>
                    </div>
                    <div class="flex space-x-2">
                        <button class="px-4 py-2 border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-bold text-xs rounded-xl shadow-sm uppercase tracking-wide transition-colors">
                            Bulk Action
                        </button>
                        <button class="px-4 py-2 border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-bold text-xs rounded-xl shadow-sm uppercase tracking-wide transition-colors">
                            Filter
                        </button>
                    </div>
                </div>

                <!-- Live Notifications Alert -->
                @if(session('success'))
                <div class="p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm font-semibold flex items-center justify-between shadow-sm">
                    <span>{{ session('success') }}</span>
                    <button @click="$el.parentElement.remove()" class="text-emerald-950 font-bold ml-4 hover:scale-110 transition-transform">✕</button>
                </div>
                @endif

                <!-- FIGMA HIGH-FIDELITY FLIGHT/HOTEL APPROVAL CARD (London Business Summit) -->
                @php
                    $londonTrip = $pendingTeamTrips->where('title', 'Flight to London (LHR)')->first();
                @endphp
                @if($londonTrip)
                <div class="bg-white p-8 rounded-[32px] border border-slate-100 shadow-sm relative overflow-hidden space-y-6 hover:shadow-md transition-all">
                    <!-- Red warning line at top since Elena's business/first flight triggers a policy warning -->
                    <div class="absolute top-0 left-0 right-0 h-1.5 bg-[#FF6B6B]"></div>
                    
                    <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
                        <div class="flex items-start space-x-4">
                            <div class="p-3 bg-[#E6F8F6] text-[#0F5B54] rounded-2xl">
                                <svg class="w-6 h-6 text-[#59BABA]" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9-2-9-18-9 18 9-2zm0 0v-8"/></svg>
                            </div>
                            <div class="space-y-1">
                                <h3 class="text-xl font-extrabold text-slate-900 tracking-tight leading-none font-outfit">London Business Summit</h3>
                                <p class="text-xs text-slate-400 font-semibold">Traveler: <span class="text-slate-800 font-bold">{{ $londonTrip->user->name }}</span> &bull; {{ $londonTrip->user->email }}</p>
                            </div>
                        </div>
                        <span class="px-3.5 py-1.5 rounded-full text-xs font-bold bg-red-50 border border-red-100 text-red-700 uppercase tracking-wide flex items-center space-x-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-red-500 inline-block mr-1"></span>
                            Policy Alert
                        </span>
                    </div>

                    <!-- Details Grid mimicking Figma -->
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-6 bg-slate-50/50 p-6 rounded-2xl border border-slate-100 text-xs font-semibold text-slate-800">
                        <div class="space-y-1">
                            <p class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">DEPARTURE</p>
                            <p class="font-extrabold text-slate-900">Oct 12, 2024</p>
                            <p class="text-[10px] text-slate-500 font-semibold">{{ $londonTrip->details['departure'] ?? 'SFO -> LHR' }}</p>
                        </div>
                        <div class="space-y-1">
                            <p class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">RETURN</p>
                            <p class="font-extrabold text-slate-900">Oct 16, 2024</p>
                            <p class="text-[10px] text-slate-500 font-semibold">{{ $londonTrip->details['arrival'] ?? 'LHR -> SFO' }}</p>
                        </div>
                        <div class="space-y-1">
                            <p class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">HOTEL</p>
                            <p class="font-extrabold text-slate-900">The Savoy</p>
                            <p class="text-[10px] text-slate-500 font-semibold">4 Nights &bull; Premium</p>
                        </div>
                        <div class="space-y-1">
                            <p class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">TOTAL BUDGET</p>
                            <p class="text-base font-black text-slate-900 leading-tight">${{ number_format($londonTrip->price, 2) }}</p>
                            <p class="text-[9px] text-[#0F5B54] bg-[#E6F8F6] px-2 py-0.5 rounded-full inline-block font-black uppercase tracking-wider mt-0.5">Project: London Ops</p>
                        </div>
                    </div>

                    <!-- Bottom Details: Avatars, Compliance Notes, Actions -->
                    <div class="flex flex-col md:flex-row items-center justify-between gap-4 pt-2">
                        <div class="flex items-center space-x-3 self-start md:self-auto">
                            <!-- Mini avatars -->
                            <div class="flex -space-x-2">
                                <img class="w-8 h-8 rounded-full border-2 border-white object-cover" src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=80" alt="team">
                                <img class="w-8 h-8 rounded-full border-2 border-white object-cover" src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=80" alt="team">
                                <div class="w-8 h-8 rounded-full bg-slate-200 border-2 border-white flex items-center justify-center text-[10px] font-black text-slate-600">+2</div>
                            </div>
                            <span class="text-xs text-slate-500 font-bold">Group booking with 2 others</span>
                        </div>

                        <!-- Main Form approvals buttons row -->
                        <div class="flex items-center space-x-3 w-full md:w-auto justify-end">
                            <button class="px-5 py-2.5 border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-bold text-xs rounded-xl shadow-sm transition-colors uppercase tracking-wider">
                                Request Info
                            </button>
                            
                            <!-- Action button: Approve -->
                            <form action="{{ route('dashboard.approve.trip', $londonTrip->id) }}" method="POST">
                                @csrf
                                <button type="submit" class="px-6 py-2.5 bg-[#59BABA] text-white hover:bg-[#48a9a9] font-black text-xs rounded-xl shadow-md shadow-[#59BABA]/15 transition-all uppercase tracking-widest active:scale-95">
                                    Approve
                                </button>
                            </form>
                            
                            <!-- Action button: Decline -->
                            <form action="{{ route('dashboard.reject.trip', $londonTrip->id) }}" method="POST">
                                @csrf
                                <button type="submit" class="px-4 py-2.5 bg-red-50 text-red-700 hover:bg-red-100 font-bold text-xs rounded-xl transition-all uppercase tracking-wider">
                                    Decline
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                @endif

                <!-- OTHER PENDING APPROVALS LIST & EXPENSES TABLE -->
                <div class="bg-white rounded-[32px] border border-slate-100 shadow-sm overflow-hidden p-6 space-y-6">
                    <div class="flex justify-between items-center pb-2 border-b border-slate-100">
                        <h3 class="text-lg font-extrabold text-slate-900 font-outfit">Active Ledger Approvals</h3>
                        <span class="text-xs text-slate-400 font-semibold">{{ $pendingTeamTrips->count() + $pendingTeamExpenses->count() }} Outstanding Requests</span>
                    </div>

                    <!-- Combined Queue (Trip & Expenses Table) -->
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-bold uppercase tracking-wider">
                                    <th class="p-4">TRAVELER</th>
                                    <th class="p-4">PURPOSE / EVENT</th>
                                    <th class="p-4">AMOUNT</th>
                                    <th class="p-4">STATUS</th>
                                    <th class="p-4 text-right">ACTION</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50 text-xs font-semibold text-slate-800">
                                
                                <!-- Render pending team trips besides London if any -->
                                @foreach($pendingTeamTrips as $trip)
                                    @if($trip->title !== 'Flight to London (LHR)')
                                    <tr class="hover:bg-slate-50/40 transition-colors">
                                        <td class="p-4">
                                            <div class="flex items-center space-x-3">
                                                <img src="{{ $trip->user->avatar }}" alt="Traveler" class="w-8 h-8 rounded-full object-cover border border-slate-100">
                                                <div>
                                                    <p class="font-extrabold text-slate-900 leading-tight">{{ $trip->user->name }}</p>
                                                    <span class="text-[9px] text-slate-400 uppercase">Acme Corp</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="p-4">
                                            <p class="font-extrabold text-slate-800">{{ $trip->title }}</p>
                                            <p class="text-[10px] text-slate-400 font-normal mt-0.5">{{ $trip->start_date->format('M d') }} - Flight segment (In-Policy)</p>
                                        </td>
                                        <td class="p-4 text-slate-900 font-black">${{ number_format($trip->price, 2) }}</td>
                                        <td class="p-4">
                                            <span class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-wider bg-amber-50 border border-amber-100 text-amber-700">Pending</span>
                                        </td>
                                        <td class="p-4 text-right">
                                            <div class="inline-flex space-x-2">
                                                <form action="{{ route('dashboard.approve.trip', $trip->id) }}" method="POST">
                                                    @csrf
                                                    <button type="submit" class="px-3 py-1 bg-[#59BABA] text-white rounded-lg text-[10px] font-bold uppercase hover:bg-[#48a9a9] transition-colors">Approve</button>
                                                </form>
                                                <form action="{{ route('dashboard.reject.trip', $trip->id) }}" method="POST">
                                                    @csrf
                                                    <button type="submit" class="px-3 py-1 bg-red-50 text-red-700 rounded-lg text-[10px] font-bold uppercase hover:bg-red-100 transition-colors">Reject</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    @endif
                                @endforeach

                                <!-- Render pending team expenses -->
                                @foreach($pendingTeamExpenses as $expense)
                                <tr class="hover:bg-slate-50/40 transition-colors">
                                    <td class="p-4">
                                        <div class="flex items-center space-x-3">
                                            <img src="{{ $expense->user->avatar }}" alt="Claimant" class="w-8 h-8 rounded-full object-cover border border-slate-100">
                                            <div>
                                                <p class="font-extrabold text-slate-900 leading-none">{{ $expense->user->name }}</p>
                                                <span class="text-[9px] text-slate-400 uppercase">Acme Corp</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="p-4">
                                        <p class="font-extrabold text-slate-800">{{ $expense->merchant }}</p>
                                        <p class="text-[10px] text-slate-400 font-normal mt-0.5">{{ $expense->category }} &bull; {{ $expense->description }}</p>
                                    </td>
                                    <td class="p-4 text-slate-900 font-black">${{ number_format($expense->amount, 2) }}</td>
                                    <td class="p-4">
                                        @if($expense->category === 'Meals' && $expense->amount > 150)
                                            <span class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-wider bg-red-50 border border-red-100 text-red-700">Flagged</span>
                                        @else
                                            <span class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-wider bg-amber-50 border border-amber-100 text-amber-700">Pending</span>
                                        @endif
                                    </td>
                                    <td class="p-4 text-right">
                                        <div class="inline-flex space-x-2">
                                            <form action="{{ route('dashboard.approve.expense', $expense->id) }}" method="POST">
                                                @csrf
                                                <button type="submit" class="px-3 py-1 bg-[#59BABA] text-white rounded-lg text-[10px] font-bold uppercase hover:bg-[#48a9a9] transition-colors">Approve</button>
                                            </form>
                                            <form action="{{ route('dashboard.reject.expense', $expense->id) }}" method="POST">
                                                @csrf
                                                <button type="submit" class="px-3 py-1 bg-red-50 text-red-700 rounded-lg text-[10px] font-bold uppercase hover:bg-red-100 transition-colors">Reject</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                @endforeach

                                @if($pendingTeamTrips->count() === 0 && $pendingTeamExpenses->count() === 0)
                                <tr>
                                    <td colspan="5" class="p-8 text-center text-slate-400 font-semibold bg-slate-50/10">No pending corporate ledger items requiring approval.</td>
                                </tr>
                                @endif

                            </tbody>
                        </table>
                    </div>
                </div>

            </main>

            <!-- RIGHT COLUMN: AI Insights & Bento Analytics (320px / w-80) -->
            <aside class="w-full md:w-80 bg-white border-l border-slate-100 p-8 space-y-8 flex-shrink-0">
                
                <!-- AI INSIGHTS CARD -->
                <div class="bg-[#FAF8FF] p-6 rounded-[28px] border border-slate-100 space-y-6 shadow-sm relative overflow-hidden">
                    <!-- Glow decoration -->
                    <div class="absolute -right-6 -bottom-6 w-20 h-20 bg-[#59BABA]/10 rounded-full filter blur-xl"></div>
                    
                    <div class="flex items-center space-x-2.5">
                        <div class="p-2 bg-white rounded-xl text-[#0F5B54] border border-slate-100 shadow-sm">
                            <svg class="w-5 h-5 text-[#59BABA]" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                        </div>
                        <h4 class="text-sm font-extrabold text-slate-900 tracking-tight font-outfit uppercase">AI Insights</h4>
                    </div>

                    <div class="space-y-4 text-xs font-semibold text-slate-700">
                        <!-- Insight 1 -->
                        <div class="space-y-1">
                            <div class="flex items-center space-x-2 text-slate-900 font-extrabold">
                                <span class="w-1.5 h-1.5 rounded-full bg-[#59BABA]"></span>
                                <span>Optimized Pricing</span>
                            </div>
                            <p class="text-[11px] text-slate-400 leading-normal pl-3.5">This trip is <span class="text-[#0F5B54] font-bold">12% below</span> average market price for this route and hotel class.</p>
                        </div>

                        <!-- Insight 2 -->
                        <div class="space-y-1">
                            <div class="flex items-center space-x-2 text-[#0F5B54] font-extrabold">
                                <span class="w-1.5 h-1.5 rounded-full bg-[#0F5B54]"></span>
                                <span>Green Travel</span>
                            </div>
                            <p class="text-[11px] text-slate-400 leading-normal pl-3.5">Flagged as sustainable. Carbon emissions are <span class="text-[#0F5B54] font-bold">18% lower</span> than the company average for similar journeys.</p>
                        </div>

                        <!-- Insight 3 -->
                        <div class="space-y-1">
                            <div class="flex items-center space-x-2 text-indigo-700 font-extrabold">
                                <span class="w-1.5 h-1.5 rounded-full bg-indigo-500"></span>
                                <span>Risk Assessment</span>
                            </div>
                            <p class="text-[11px] text-slate-400 leading-normal pl-3.5">Travel insurance and emergency support coverage confirmed for the UK region.</p>
                        </div>
                    </div>

                    <button class="w-full py-2 bg-white border border-slate-200 hover:bg-slate-50 text-slate-700 font-bold text-[10px] rounded-xl transition-colors uppercase tracking-wider">
                        View Full Analysis
                    </button>
                </div>

                <!-- MONTHLY SAVINGS BENTO CARD -->
                <div class="bg-white p-6 rounded-[28px] border border-slate-100 shadow-sm space-y-3">
                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Monthly Savings</p>
                    <div class="flex justify-between items-end">
                        <div>
                            <p class="text-xs text-slate-400 font-semibold leading-none">Policy Savings</p>
                            <p class="text-3xl font-black text-slate-900 font-outfit mt-1 leading-none">+$1,450</p>
                        </div>
                        <span class="text-[9px] bg-green-50 text-green-700 font-bold px-2 py-0.5 rounded-full">Goal: $2k</span>
                    </div>
                    
                    <!-- Progress bar -->
                    <div class="space-y-1.5 pt-2">
                        <div class="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                            <div class="h-full bg-[#59BABA] rounded-full" style="width: 75%;"></div>
                        </div>
                        <p class="text-[9px] text-slate-400 font-bold">75% of goal achieved this quarter</p>
                    </div>
                </div>

                <!-- TRAVEL DISTRIBUTION BENTO CARD -->
                <div class="bg-[#FAF8FF] p-6 rounded-[28px] border border-slate-100 shadow-sm space-y-4 overflow-hidden relative min-h-[160px] flex flex-col justify-between">
                    <div>
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Travel Distribution</p>
                        <p class="text-xs text-slate-500 font-bold">Global Flight Map</p>
                    </div>
                    
                    <!-- Premium visual SVG globe mockup mimicking Figma flight map -->
                    <div class="absolute -right-4 -bottom-4 w-40 h-40 bg-slate-200/50 rounded-full border border-slate-300/30 overflow-hidden flex items-center justify-center shadow-inner">
                        <svg class="w-full h-full text-slate-400/20" fill="none" stroke="currentColor" stroke-width="1" viewBox="0 0 100 100">
                            <!-- Latitude / Longitude lines -->
                            <circle cx="50" cy="50" r="45" stroke-dasharray="2,2"/>
                            <ellipse cx="50" cy="50" rx="30" ry="45" stroke-dasharray="2,2"/>
                            <ellipse cx="50" cy="50" rx="15" ry="45" stroke-dasharray="2,2"/>
                            <line x1="5" y1="50" x2="95" y2="50"/>
                            
                            <!-- Arc Flight Lines -->
                            <path d="M 20 60 Q 50 20 80 50" fill="none" stroke="#59BABA;" stroke-width="2" stroke-dasharray="2,2"/>
                            <circle cx="20" cy="60" r="3" fill="#59BABA"/>
                            <circle cx="80" cy="50" r="3" fill="#59BABA"/>
                            
                            <path d="M 30 70 Q 50 30 70 40" fill="none" stroke="#0F5B54" stroke-width="1.5"/>
                            <circle cx="30" cy="70" r="2" fill="#0F5B54"/>
                            <circle cx="70" cy="40" r="2" fill="#0F5B54"/>
                        </svg>
                    </div>
                </div>

            </aside>

        </div>

    @else
        <!-- ================= EMPLOYEE MODE: CORPORATE PORTAL ================= -->
        <!-- Global App Header -->
        <header class="bg-brand-950 text-white sticky top-0 z-40 shadow-md">
            <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                <div class="flex items-center space-x-6">
                    <a href="/" class="text-2xl font-black tracking-tight hover:opacity-90 transition-opacity">AVIAJ</a>
                    <span class="text-xs tracking-wider font-bold bg-brand-800 text-brand-200 px-3 py-1 rounded-full uppercase">Corporate Portal</span>
                </div>
                
                <!-- Role Toggle switch inside Employee Header -->
                <div class="flex items-center space-x-4">
                    <form action="{{ route('dashboard.toggle-role') }}" method="POST" class="mr-2">
                        @csrf
                        <button type="submit" class="flex items-center space-x-2 bg-brand-900/90 hover:bg-brand-800 px-4 py-2.5 rounded-xl border border-brand-800 transition-all text-xs font-bold tracking-wider shadow-sm active:scale-98">
                            <span class="text-brand-300 font-medium">Mode:</span>
                            <span class="px-2 py-0.5 rounded text-[10px] uppercase font-black tracking-widest bg-[#59BABA] text-brand-950 shadow-inner">
                                Employee View
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

            <!-- Stats Grid -->
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
                    <div class="p-3 bg-[#59BABA]/10 text-brand-950 rounded-2xl">
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
                                        
                                        <!-- Trip Details -->
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

                <!-- Right Area: Virtual Cards List -->
                <div class="lg:col-span-4 space-y-6">
                    <div class="flex justify-between items-center">
                        <h2 class="text-xl font-extrabold text-brand-950 tracking-tight font-sans">Virtual Cards</h2>
                        <button @click="showCardModal = true" class="text-xs font-bold uppercase tracking-wider text-indigo-600 hover:text-indigo-800">
                            + Issue Card
                        </button>
                    </div>

                    <div class="space-y-6">
                        @forelse($cards as $card)
                        <div class="relative group">
                            <div :class="'{{ $card->status }}' === 'paused' ? 'opacity-60 saturate-50' : ''" class="bg-gradient-to-br from-brand-900 to-indigo-950 text-white p-6 rounded-2xl shadow-xl relative overflow-hidden transition-all duration-300">
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
                                        <p class="text-[9px] text-[#59BABA] uppercase tracking-widest">Expires</p>
                                        <p class="text-xs font-semibold">{{ $card->expiry_date }}</p>
                                    </div>
                                </div>
                            </div>

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
    @endif

    <!-- Modals -->
    <!-- Modal 1: Submit Expense Claim -->
    <div x-show="showExpenseModal" class="fixed inset-0 bg-brand-950/50 backdrop-blur-sm flex items-center justify-center z-50 p-6" x-transition x-cloak>
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
    <div x-show="showCardModal" class="fixed inset-0 bg-brand-950/50 backdrop-blur-sm flex items-center justify-center z-50 p-6" x-transition x-cloak>
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
