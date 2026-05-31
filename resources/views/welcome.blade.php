<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business travel & expense management. Solved. | Aviaj</title>
    <meta name="description" content="The AI-powered platform designed for the modern enterprise. From booking trips to reconciling spend, manage every aspect of corporate travel effortlessly.">
    
    <!-- Modern Premium Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="font-sans text-[#0F172A] bg-[#FFFFFF] antialiased overflow-x-hidden selection:bg-[#3A9F9F]/20">

    <!-- Premium Glassmorphic Navigation Bar -->
    <header class="fixed top-0 inset-x-0 z-50 transition-all duration-300 border-b border-slate-100 bg-white/80 backdrop-blur-xl">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <!-- Brand Logo -->
            <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold tracking-tight text-[#0F172A] transition-transform duration-300 hover:scale-102">
                <span class="bg-gradient-to-r from-[#3A9F9F] to-indigo-600 bg-clip-text text-transparent">AVIAJ</span>
                <span class="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] tracking-widest">Premium Style</span>
            </a>

            <!-- Navigation Links -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-[#64748B]">
                <a href="#travel" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Travel</a>
                <a href="#expense" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Expense</a>
                <a href="#bento" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Solutions</a>
                <a href="#cta" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Pricing</a>
            </nav>

            <!-- Action Buttons -->
            <div class="flex items-center space-x-4">
                <a href="{{ route('dashboard') }}" class="hidden sm:inline-flex items-center justify-center font-semibold text-[#64748B] hover:text-[#0F172A] transition-colors">Login</a>
                <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-5 py-2.5 font-semibold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-sm shadow-[#3A9F9F]/20 hover:shadow-md hover:-translate-y-0.5 transition-all duration-200">
                    Get Started
                </a>
            </div>
        </div>
    </header>

    <!-- Interactive Hero Section -->
    <section class="relative pt-36 pb-20 lg:pt-48 lg:pb-32 bg-gradient-to-b from-slate-50 via-white to-white overflow-hidden">
        <!-- Floating Ambient Background Orbs -->
        <div class="absolute top-1/4 left-1/10 w-96 h-96 bg-[#3A9F9F]/10 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-pulse"></div>
        <div class="absolute top-1/3 right-1/10 w-96 h-96 bg-indigo-200/20 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-pulse" style="animation-delay: 2s;"></div>

        <div class="max-w-7xl mx-auto px-6 relative z-10">
            <div class="grid lg:grid-cols-12 gap-16 items-center">
                
                <!-- Left Column: Premium Content & Title -->
                <div class="lg:col-span-7 space-y-8 text-left">
                    <!-- Pill Tag -->
                    <div class="inline-flex items-center space-x-2.5 px-3.5 py-1.5 rounded-full bg-[#3A9F9F]/10 border border-[#3A9F9F]/20 text-[#3A9F9F] text-xs font-semibold tracking-wide">
                        <!-- Custom star icon SVG -->
                        <svg class="w-3.5 h-3.5 text-[#3A9F9F]" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        <span>4.7 out of 5 | 9K+ reviews</span>
                    </div>

                    <h1 class="text-4xl sm:text-6xl font-extrabold tracking-tight text-[#0F172A] font-sans leading-tight">
                        Business travel & expense <br>
                        management. <span class="bg-gradient-to-r from-[#3A9F9F] to-indigo-600 bg-clip-text text-transparent">Solved.</span>
                    </h1>

                    <p class="text-lg text-[#64748B] max-w-xl leading-relaxed">
                        The AI-powered platform designed for the modern enterprise. From booking trips to reconciling spend, manage every aspect of corporate travel effortlessly.
                    </p>

                    <!-- Interactive Search / Booking Widget -->
                    <div class="bg-white border border-slate-150 p-6 rounded-2xl shadow-xl space-y-4 max-w-xl">
                        <!-- Navigation tabs within the search widget -->
                        <div class="flex space-x-1 border-b border-slate-100 pb-3 overflow-x-auto scrollbar-none">
                            <button class="px-4 py-2 text-xs font-bold rounded-lg transition-all duration-200 bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center space-x-1.5 shrink-0">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/></svg>
                                <span>Book Trip</span>
                            </button>
                            <button class="px-4 py-2 text-xs font-semibold rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all shrink-0">
                                <span>Manage Cards</span>
                            </button>
                            <button class="px-4 py-2 text-xs font-semibold rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all shrink-0">
                                <span>Team Offsite</span>
                            </button>
                            <button class="px-4 py-2 text-xs font-semibold rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all shrink-0">
                                <span>View Reports</span>
                            </button>
                        </div>

                        <!-- Active tab component: Book Trip search input -->
                        <div class="flex flex-col sm:flex-row gap-3 pt-1">
                            <div class="flex-1 relative">
                                <span class="absolute left-3.5 top-3.5 text-slate-400">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                                </span>
                                <input type="text" placeholder="Where to?" class="w-full bg-slate-50 border border-slate-200 focus:border-[#3A9F9F] focus:bg-white focus:ring-1 focus:ring-[#3A9F9F] pl-11 pr-4 py-3 rounded-lg text-sm text-[#0F172A] outline-none transition-all placeholder:text-slate-400">
                            </div>
                            <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3 font-semibold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-sm shadow-[#3A9F9F]/20 hover:shadow-md transition-all duration-200 shrink-0 text-sm">
                                <span>Search Flights</span>
                                <svg class="w-4 h-4 ml-1.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Interactive Mockup and Graphics -->
                <div class="lg:col-span-5 relative mt-8 lg:mt-0">
                    <!-- Glow decoration behind mockup -->
                    <div class="absolute -inset-2 bg-gradient-to-tr from-[#3A9F9F]/30 to-indigo-500/20 rounded-2xl blur-2xl opacity-60"></div>
                    
                    <!-- Main Dashboard Visual Container -->
                    <div class="relative bg-white border border-slate-100 p-6 rounded-2xl shadow-2xl backdrop-blur-xl">
                        <!-- Top Decor: Mock window controller -->
                        <div class="flex space-x-1.5 pb-4 border-b border-slate-50">
                            <span class="w-3 h-3 bg-red-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-yellow-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-green-400 rounded-full"></span>
                            <span class="text-xs text-slate-400 font-mono pl-4">Sarah Jenkins &bull; Travel Manager</span>
                        </div>

                        <!-- Content Mockup -->
                        <div class="space-y-6 pt-4 relative">
                            <!-- Traveler Visual -->
                            <div class="h-60 rounded-xl overflow-hidden bg-slate-100 border border-slate-100 flex items-center justify-center relative">
                                <div class="absolute inset-0 bg-gradient-to-t from-slate-900/60 to-transparent z-10"></div>
                                <img src="https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&q=80&w=800" alt="Professional Traveler" class="w-full h-full object-cover">
                                <div class="absolute bottom-4 left-4 z-20 text-white">
                                    <h4 class="text-sm font-bold">Sarah Jenkins</h4>
                                    <p class="text-[10px] text-slate-200">En route to SFO airport</p>
                                </div>
                            </div>

                            <!-- Floating Card 1: Itinerary (Absolute Positioned over image for premium look) -->
                            <div class="absolute top-24 -left-6 bg-white border border-slate-100 p-4 rounded-xl shadow-lg w-56 space-y-3 z-30 transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                                <div class="flex justify-between items-center">
                                    <div class="flex items-center space-x-1.5">
                                        <div class="w-5 h-5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center">
                                            <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20"><path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z"></path></svg>
                                        </div>
                                        <span class="text-[10px] font-bold text-slate-800 tracking-tight">Trip Itinerary</span>
                                    </div>
                                    <span class="text-[9px] font-bold uppercase text-[#3A9F9F] bg-[#3A9F9F]/10 px-1.5 py-0.5 rounded">Confirmed</span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <div>
                                        <span class="text-xs font-black text-slate-900 block">SFO</span>
                                        <span class="text-[9px] text-slate-400">8:45 AM</span>
                                    </div>
                                    <div class="w-12 border-t-2 border-dashed border-slate-200 relative flex items-center justify-center">
                                        <span class="absolute -top-1.5 text-slate-400">
                                            <svg class="w-3.5 h-3.5 transform rotate-90" fill="currentColor" viewBox="0 0 20 20"><path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z"></path></svg>
                                        </span>
                                    </div>
                                    <div class="text-right">
                                        <span class="text-xs font-black text-slate-900 block">LHR</span>
                                        <span class="text-[9px] text-slate-400">2:20 PM</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Floating Card 2: Receipt (Absolute Positioned for high fidelity overlay) -->
                            <div class="absolute bottom-6 -right-6 bg-white border border-slate-100 p-4 rounded-xl shadow-lg w-52 space-y-2 z-30 transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                                <div class="flex items-center space-x-1.5">
                                    <div class="w-4.5 h-4.5 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center">
                                        <span class="text-xs font-bold">&check;</span>
                                    </div>
                                    <span class="text-[9px] font-bold text-emerald-600">Auto-reconciled</span>
                                </div>
                                <div class="flex justify-between items-end">
                                    <div>
                                        <span class="text-[9px] text-slate-400 block">Dinner Expense</span>
                                        <span class="text-base font-extrabold text-slate-900">$45.00</span>
                                    </div>
                                    <div class="flex -space-x-1.5">
                                        <div class="w-5 h-5 rounded-full bg-indigo-500 text-white flex items-center justify-center font-bold text-[8px] border border-white">M</div>
                                        <div class="w-5 h-5 rounded-full bg-[#3A9F9F] text-white flex items-center justify-center font-bold text-[8px] border border-white">J</div>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Social Proof Grid Section -->
    <section class="py-12 bg-slate-50 border-y border-slate-100">
        <div class="max-w-7xl mx-auto px-6 space-y-6">
            <span class="text-[10px] uppercase font-bold text-slate-400 tracking-widest text-center block">TRUSTED BY THOUSANDS OF INNOVATIVE COMPANIES</span>
            <div class="flex flex-wrap items-center justify-center gap-10 md:gap-16 opacity-50 grayscale hover:opacity-75 transition-opacity duration-300">
                <span class="text-sm font-black tracking-widest">DATADOG</span>
                <span class="text-sm font-black tracking-widest">NILFISK</span>
                <span class="text-sm font-black tracking-widest">MONGODB</span>
                <span class="text-sm font-black tracking-widest">PRIMARK</span>
                <span class="text-sm font-black tracking-widest">ZOOM</span>
                <span class="text-sm font-black tracking-widest">CANVA</span>
            </div>
        </div>
    </section>

    <!-- Feature Section 1: One-Stop Shop (Travel) -->
    <section id="travel" class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                
                <!-- Left: Visual showcase card -->
                <div class="relative">
                    <div class="absolute -inset-2 bg-gradient-to-tr from-[#3A9F9F]/20 to-indigo-500/10 rounded-2xl blur-xl opacity-60"></div>
                    <div class="relative bg-white border border-slate-100 rounded-2xl shadow-xl overflow-hidden">
                        <div class="p-4 border-b border-slate-50 bg-slate-50/50 flex justify-between items-center">
                            <span class="text-xs font-bold text-[#0F172A]">Aviaj Travel Booking Interface</span>
                            <span class="text-[10px] text-slate-400">v4.0</span>
                        </div>
                        <img src="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=800" alt="Aviaj Travel Booking" class="w-full h-72 object-cover">
                    </div>
                </div>

                <!-- Right: Content -->
                <div class="space-y-8">
                    <div class="space-y-4">
                        <span class="text-xs font-bold uppercase tracking-widest text-[#3A9F9F]">AVIAJ TRAVEL</span>
                        <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0F172A] tracking-tight font-sans leading-tight">
                            One-Stop Shop for Business Travel
                        </h2>
                        <p class="text-sm text-[#64748B] leading-relaxed">
                            Build, manage, and scale your company’s travel program with ease. Empower employees to book from an extensive inventory while staying within your spending limits. Our AI-driven engine suggests the best options based on historical preferences and corporate policy.
                        </p>
                    </div>

                    <div class="space-y-4">
                        <div class="flex items-start space-x-3 text-xs">
                            <div class="w-5 h-5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center shrink-0 mt-0.5">&check;</div>
                            <span class="text-slate-700">Global inventory of flights, hotels, and car rentals</span>
                        </div>
                        <div class="flex items-start space-x-3 text-xs">
                            <div class="w-5 h-5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center shrink-0 mt-0.5">&check;</div>
                            <span class="text-slate-700">Real-time policy compliance checks at checkout</span>
                        </div>
                        <div class="flex items-start space-x-3 text-xs">
                            <div class="w-5 h-5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center shrink-0 mt-0.5">&check;</div>
                            <span class="text-slate-700">24/7 dedicated travel support for all employees</span>
                        </div>
                    </div>

                    <div class="pt-2">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center space-x-2 text-xs font-bold text-[#3A9F9F] hover:text-[#3A9F9F]/80 transition-colors">
                            <span>Learn more about Aviaj Travel</span>
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Feature Section 2: Centralized Spend (Expense) -->
    <section id="expense" class="py-20 bg-slate-50 border-t border-slate-100">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                
                <!-- Left: Content -->
                <div class="space-y-8 order-2 lg:order-1">
                    <div class="space-y-4">
                        <span class="text-xs font-bold uppercase tracking-widest text-[#3A9F9F]">AVIAJ EXPENSE</span>
                        <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0F172A] tracking-tight font-sans leading-tight">
                            Centralized Spend & Real-time Visibility
                        </h2>
                        <p class="text-sm text-[#64748B] leading-relaxed">
                            Streamline your expense management from swipe to reconciliation. Automate categorization, reports, and reimbursements. Boost productivity and optimize savings with AI-powered insights that flag out-of-policy spending before it happens.
                        </p>
                    </div>

                    <!-- Side-by-side stats -->
                    <div class="grid grid-cols-2 gap-6 pt-2">
                        <div class="bg-white border border-slate-100 p-5 rounded-xl shadow-sm">
                            <span class="text-3xl font-extrabold text-[#3A9F9F] block">90%</span>
                            <span class="text-[10px] font-semibold text-slate-500 uppercase tracking-wider block mt-1">Reduction in manual reporting</span>
                        </div>
                        <div class="bg-white border border-slate-100 p-5 rounded-xl shadow-sm">
                            <span class="text-3xl font-extrabold text-[#3A9F9F] block">Instant</span>
                            <span class="text-[10px] font-semibold text-slate-500 uppercase tracking-wider block mt-1">Policy violation detection</span>
                        </div>
                    </div>

                    <div class="pt-2">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center space-x-2 text-xs font-bold text-[#3A9F9F] hover:text-[#3A9F9F]/80 transition-colors">
                            <span>Explore Expense Management</span>
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
                        </a>
                    </div>
                </div>

                <!-- Right: Visual showcase card -->
                <div class="relative order-1 lg:order-2">
                    <div class="absolute -inset-2 bg-gradient-to-tr from-indigo-500/20 to-[#3A9F9F]/10 rounded-2xl blur-xl opacity-60"></div>
                    <div class="relative bg-white border border-slate-100 rounded-2xl shadow-xl overflow-hidden">
                        <div class="p-4 border-b border-slate-50 bg-slate-50/50 flex justify-between items-center">
                            <span class="text-xs font-bold text-[#0F172A]">Real-Time Outflow Ledger</span>
                            <span class="text-[10px] text-slate-400">Live Stream</span>
                        </div>
                        <img src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=800" alt="Expense Ledger Dashboard" class="w-full h-72 object-cover">
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Bento Grid Section (Best Companion) -->
    <section id="bento" class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-6">
            
            <!-- Section Header -->
            <div class="text-center max-w-2xl mx-auto mb-16 space-y-4">
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0F172A] tracking-tight">
                    Every traveler's best companion
                </h2>
                <p class="text-[#64748B] font-light text-base leading-relaxed">
                    Designed to serve the needs of everyone in your organization, from the frequent flyer to the CFO.
                </p>
            </div>

            <!-- Bento Cards -->
            <div class="grid md:grid-cols-3 gap-8">
                <!-- Card 1: Road Warriors -->
                <div class="p-8 rounded-2xl bg-[#3A9F9F]/5 hover:bg-[#3A9F9F]/10 border border-[#3A9F9F]/10 shadow-sm transition-all duration-300 group flex flex-col justify-between h-80">
                    <div class="space-y-4">
                        <span class="text-2xl block group-hover:scale-105 transition-transform">✈️</span>
                        <h3 class="text-xl font-bold text-[#0F172A]">Road Warriors</h3>
                        <p class="text-[#64748B] text-xs leading-relaxed font-light">
                            Book and manage everything in one tap. Earn rewards for your personal trips while staying compliant.
                        </p>
                    </div>
                    <div class="pt-4">
                        <a href="{{ route('demo-login') }}" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
                            Learn more
                        </a>
                    </div>
                </div>

                <!-- Card 2: Travel Managers -->
                <div class="p-8 rounded-2xl bg-[#3A9F9F]/5 hover:bg-[#3A9F9F]/10 border border-[#3A9F9F]/10 shadow-sm transition-all duration-300 group flex flex-col justify-between h-80">
                    <div class="space-y-4">
                        <span class="text-2xl block group-hover:scale-105 transition-transform">🛡️</span>
                        <h3 class="text-xl font-bold text-[#0F172A]">Travel Managers</h3>
                        <p class="text-[#64748B] text-xs leading-relaxed font-light">
                            Set guardrails and know where your team is at all times. Protect budgets with auto-matched expense constraints.
                        </p>
                    </div>
                    <div class="pt-4">
                        <a href="{{ route('demo-login') }}" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
                            Learn more
                        </a>
                    </div>
                </div>

                <!-- Card 3: Finance -->
                <div class="p-8 rounded-2xl bg-[#3A9F9F]/5 hover:bg-[#3A9F9F]/10 border border-[#3A9F9F]/10 shadow-sm transition-all duration-300 group flex flex-col justify-between h-80">
                    <div class="space-y-4">
                        <span class="text-2xl block group-hover:scale-105 transition-transform">💼</span>
                        <h3 class="text-xl font-bold text-[#0F172A]">Finance & Accounting</h3>
                        <p class="text-[#64748B] text-xs leading-relaxed font-light">
                            Automated reconciliation and real-time visibility into every penny spent. Sync transactions seamlessly with ERP.
                        </p>
                    </div>
                    <div class="pt-4">
                        <a href="{{ route('demo-login') }}" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
                            Learn more
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- Call To Action Section -->
    <section id="cta" class="py-24 bg-slate-900 text-white relative overflow-hidden border-t border-slate-800">
        <!-- background blur decor -->
        <div class="absolute -right-20 -top-20 w-80 h-80 bg-[#3A9F9F]/10 rounded-full filter blur-3xl"></div>
        <div class="absolute -left-20 -bottom-20 w-80 h-80 bg-indigo-500/10 rounded-full filter blur-3xl"></div>

        <div class="max-w-4xl mx-auto px-6 text-center space-y-8 relative z-10">
            <h2 class="text-3xl sm:text-5xl font-extrabold tracking-tight leading-tight">
                Ready to transform your T&E?
            </h2>
            <div class="flex flex-col sm:flex-row justify-center gap-4 pt-2">
                <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200">
                    Get Started for Free
                </a>
                <a href="#bento" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-transparent hover:bg-white/5 border border-white/20 rounded-lg transition-all duration-200">
                    Request a Demo
                </a>
            </div>
            <p class="text-slate-400 text-xs font-light tracking-wide">
                No credit card required. Setup takes less than 5 minutes.
            </p>
        </div>
    </section>

    <!-- Comprehensive Footer -->
    <footer class="pt-20 pb-12 bg-white border-t border-slate-100 text-[#0F172A]">
        <div class="max-w-7xl mx-auto px-6">
            
            <div class="grid grid-cols-2 md:grid-cols-12 gap-10 md:gap-8 pb-16">
                <!-- Brand Column -->
                <div class="col-span-2 md:col-span-4 space-y-6">
                    <a href="/" class="text-2xl font-black bg-gradient-to-r from-[#3A9F9F] to-indigo-600 bg-clip-text text-transparent">AVIAJ</a>
                    <p class="text-xs text-[#64748B] leading-relaxed max-w-xs font-light">
                        Precise corporate travel and expense management for modern teams.
                    </p>
                    <div class="flex space-x-3 pt-2">
                        <a href="https://github.com/manjot/aviaj" class="w-8 h-8 rounded-full border border-slate-200 hover:border-[#3A9F9F] hover:text-[#3A9F9F] flex items-center justify-center text-[#64748B] transition-all">
                            <span class="font-bold text-xs font-mono">GH</span>
                        </a>
                    </div>
                </div>

                <!-- Product Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Product</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#travel" class="hover:text-[#0F172A] transition-colors">Travel</a></li>
                        <li><a href="#expense" class="hover:text-[#0F172A] transition-colors">Expense</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Rewards</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Payments</a></li>
                    </ul>
                </div>

                <!-- Solutions Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Solutions</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Enterprises</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Small Business</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">By Industry</a></li>
                    </ul>
                </div>

                <!-- Company Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Company</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">About Us</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Careers</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Press</a></li>
                    </ul>
                </div>

                <!-- Legal Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Legal</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Terms of Service</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Privacy Policy</a></li>
                        <li><a href="#bento" class="hover:text-[#0F172A] transition-colors">Security</a></li>
                    </ul>
                </div>

            </div>

            <!-- Bottom Copyright border -->
            <div class="pt-8 border-t border-slate-100 flex flex-col sm:flex-row justify-between items-center gap-4">
                <p class="text-[11px] text-[#64748B] font-light">
                    &copy; 2026 Aviaj. All rights reserved. Precise corporate travel and expense management.
                </p>
                <div class="flex space-x-6 text-[11px] text-[#64748B] font-light">
                    <a href="{{ route('demo-login') }}" class="hover:text-[#0F172A]">Enter Demo App</a>
                    <a href="https://github.com/manjot/aviaj" class="hover:text-[#0F172A]">GitHub</a>
                </div>
            </div>

        </div>
    </footer>

</body>
</html>
