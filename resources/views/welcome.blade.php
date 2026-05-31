<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solutions for Travel Managers | Aviaj</title>
    <meta name="description" content="Total control over your global travel program. Empower your team to book the travel they love while maintaining complete visibility and policy compliance with AI-driven automation.">
    
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
            <!-- Brand Logo with Figma Color Accent -->
            <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold tracking-tight text-[#0F172A] transition-transform duration-300 hover:scale-102">
                <span class="bg-gradient-to-r from-[#3A9F9F] to-indigo-600 bg-clip-text text-transparent">AVIAJ</span>
                <span class="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] tracking-widest">Premium Style</span>
            </a>

            <!-- Navigation Links -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-[#64748B]">
                <a href="#features" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Travel</a>
                <a href="#features" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Expense</a>
                <a href="#showcase" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Analytics</a>
                <a href="#showcase" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Resources</a>
                <a href="#showcase" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#3A9F9F] after:transition-all">Company</a>
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
                    <div class="inline-flex items-center space-x-2 px-3.5 py-1.5 rounded-full bg-[#3A9F9F]/10 border border-[#3A9F9F]/20 text-[#3A9F9F] text-xs font-semibold tracking-wide">
                        <span class="flex h-2 w-2 rounded-full bg-[#3A9F9F] animate-ping"></span>
                        <span>Solutions for Travel Managers</span>
                    </div>

                    <h1 class="text-4xl sm:text-6xl font-extrabold tracking-tight text-[#0F172A] font-sans leading-tight">
                        Total control over your <br>
                        <span class="bg-gradient-to-r from-[#3A9F9F] to-indigo-600 bg-clip-text text-transparent">global travel program.</span>
                    </h1>

                    <p class="text-lg text-[#64748B] max-w-xl leading-relaxed">
                        Empower your team to book the travel they love while maintaining complete visibility and policy compliance with AI-driven automation.
                    </p>

                    <!-- Call To Actions -->
                    <div class="flex flex-col sm:flex-row gap-4 pt-2">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-lg shadow-[#3A9F9F]/10 hover:shadow-xl hover:-translate-y-0.5 active:translate-y-0 active:scale-98 transition-all duration-200">
                            Request a demo
                        </a>
                        <a href="#features" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-[#0F172A] bg-white hover:bg-slate-50 border border-slate-200 rounded-lg shadow-sm hover:shadow active:scale-98 transition-all duration-200 group">
                            <span>Watch video</span>
                            <svg class="w-4 h-4 ml-2.5 text-[#64748B] group-hover:text-[#0F172A] transition-colors" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path></svg>
                        </a>
                    </div>
                </div>

                <!-- Right Column: Interactive Mockup and Graphics -->
                <div class="lg:col-span-5 relative mt-8 lg:mt-0">
                    <!-- Glow decoration behind mockup -->
                    <div class="absolute -inset-2 bg-gradient-to-tr from-[#3A9F9F]/30 to-indigo-500/20 rounded-2xl blur-2xl opacity-60"></div>
                    
                    <!-- Main Dashboard Container -->
                    <div class="relative bg-white border border-slate-100 p-6 rounded-2xl shadow-2xl backdrop-blur-xl">
                        <!-- Top Decor: Mock window controller -->
                        <div class="flex space-x-1.5 pb-4 border-b border-slate-50">
                            <span class="w-3 h-3 bg-red-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-yellow-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-green-400 rounded-full"></span>
                            <span class="text-xs text-slate-400 font-mono pl-4">Sarah Jenkins &bull; Travel Manager</span>
                        </div>

                        <!-- Content Mockup -->
                        <div class="space-y-6 pt-4">
                            <!-- Card Platform Header -->
                            <div class="flex justify-between items-center">
                                <span class="text-[10px] font-bold uppercase text-[#64748B] tracking-wider">AVIAJ VIRTUAL CARDS</span>
                                <span class="px-2.5 py-0.5 bg-emerald-50 text-emerald-600 text-xs font-bold rounded-full border border-emerald-100">Policy Compliant</span>
                            </div>

                            <!-- Interactive Card Preview -->
                            <div class="bg-gradient-to-br from-slate-900 to-indigo-950 text-white p-6 rounded-xl shadow-lg relative overflow-hidden group">
                                <div class="absolute -right-10 -bottom-10 w-40 h-40 bg-[#3A9F9F]/10 rounded-full filter blur-2xl transition-transform group-hover:scale-110"></div>
                                
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="text-[9px] text-[#3A9F9F] font-bold uppercase tracking-widest">Company Travel Card</p>
                                        <h3 class="text-base font-bold tracking-wide mt-1">Acme Corp</h3>
                                    </div>
                                    <div class="text-lg font-black italic tracking-tighter text-slate-300">VISA</div>
                                </div>
                                <div class="mt-8">
                                    <p class="text-base font-mono tracking-widest">•••• •••• •••• 8824</p>
                                </div>
                                <div class="mt-4 flex justify-between items-end">
                                    <div>
                                        <p class="text-[8px] text-slate-400 uppercase tracking-widest">Cardholder</p>
                                        <p class="text-xs font-semibold text-white">Sarah Jenkins</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-[8px] text-slate-400 uppercase tracking-widest">Expires</p>
                                        <p class="text-xs font-semibold text-white">08/30</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Live Transaction Stream Preview -->
                            <div class="space-y-3">
                                <p class="text-[10px] font-bold uppercase text-[#64748B] tracking-wider">Recent Outlays</p>
                                
                                <div class="flex justify-between items-center p-3 bg-slate-50 border border-slate-100/60 rounded-xl hover:bg-slate-100/50 transition-colors">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 bg-indigo-50 text-indigo-600 flex items-center justify-center rounded-lg font-bold text-xs">U</div>
                                        <div>
                                            <p class="text-xs font-bold text-[#0F172A]">Uber Ride - SFO</p>
                                            <p class="text-[9px] text-[#64748B]">Approved &bull; Policy OK</p>
                                        </div>
                                    </div>
                                    <span class="text-xs font-bold text-[#0F172A]">-$42.50</span>
                                </div>

                                <div class="flex justify-between items-center p-3 bg-slate-50 border border-slate-100/60 rounded-xl hover:bg-slate-100/50 transition-colors">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 bg-emerald-50 text-emerald-600 flex items-center justify-center rounded-lg font-bold text-xs">R</div>
                                        <div>
                                            <p class="text-xs font-bold text-[#0F172A]">The Ritz-Carlton, SFO</p>
                                            <p class="text-[9px] text-[#64748B]">Lodging &bull; Auto matched</p>
                                        </div>
                                    </div>
                                    <span class="text-xs font-bold text-[#0F172A]">-$1,200.00</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Product Features Bento Grid -->
    <section id="features" class="py-20 bg-slate-50 border-y border-slate-100">
        <div class="max-w-7xl mx-auto px-6">
            
            <!-- Section Header -->
            <div class="text-center max-w-2xl mx-auto mb-16 space-y-4">
                <span class="text-xs font-bold uppercase tracking-widest text-[#3A9F9F]">UNIFIED CONTROL</span>
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0F172A] tracking-tight">
                    Precision Management Tools
                </h2>
                <p class="text-[#64748B] font-light text-base leading-relaxed">
                    Modern infrastructure designed to handle the complexity of corporate logistics with simple, intuitive workflows.
                </p>
            </div>

            <!-- Bento Grid Layout -->
            <div class="grid md:grid-cols-12 gap-8">
                
                <!-- Card 1: Invite Employees (Span 7) -->
                <div class="md:col-span-7 p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md hover:border-slate-200 transition-all duration-300 flex flex-col justify-between group">
                    <div class="space-y-4">
                        <div class="w-10 h-10 bg-[#3A9F9F]/10 rounded-lg flex items-center justify-center text-[#3A9F9F] group-hover:scale-105 transition-transform duration-300">
                            <!-- SVG Invite Icon -->
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0F172A]">Invite employees & guests</h3>
                        <p class="text-[#64748B] text-sm leading-relaxed max-w-md font-light">
                            Onboard your entire organization in minutes. Set granular permissions for frequent travelers, executive assistants, and occasional guest speakers with automated invite sequences.
                        </p>
                    </div>

                    <!-- Visual Demo Component -->
                    <div class="mt-8 bg-slate-50 border border-slate-100 rounded-xl p-4 space-y-3">
                        <div class="flex justify-between items-center bg-white p-3 rounded-lg border border-slate-100/50 shadow-sm">
                            <div class="flex items-center space-x-3">
                                <div class="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center font-bold text-xs text-slate-700">SJ</div>
                                <span class="text-xs font-semibold text-slate-800">Sarah Jenkins</span>
                            </div>
                            <span class="text-[10px] font-bold uppercase tracking-wider text-[#3A9F9F] bg-[#3A9F9F]/10 px-2 py-0.5 rounded">Sent</span>
                        </div>
                        <div class="flex justify-between items-center bg-white p-3 rounded-lg border border-slate-100/50 shadow-sm">
                            <div class="flex items-center space-x-3">
                                <div class="w-8 h-8 rounded-full bg-indigo-50 flex items-center justify-center font-bold text-xs text-indigo-700">MT</div>
                                <span class="text-xs font-semibold text-slate-800">Mark Thompson</span>
                            </div>
                            <span class="text-[10px] font-bold uppercase tracking-wider text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded">Accepted</span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Spend Guardrails (Span 5) -->
                <div class="md:col-span-5 p-8 rounded-2xl bg-slate-900 border border-slate-850 shadow-sm hover:shadow-md transition-all duration-300 flex flex-col justify-between text-white group">
                    <div class="space-y-4">
                        <div class="w-10 h-10 bg-white/10 rounded-lg flex items-center justify-center text-[#3A9F9F] group-hover:scale-105 transition-transform duration-300">
                            <!-- SVG Lock Icon -->
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold">Set spend guardrails</h3>
                        <p class="text-slate-400 text-sm leading-relaxed font-light">
                            Automate policy enforcement at the point of search. Prevent out-of-policy bookings before they happen with real-time dynamic budget limits.
                        </p>
                    </div>

                    <!-- Visual Demo Badge -->
                    <div class="mt-8 flex justify-center">
                        <div class="px-6 py-4 rounded-xl border border-white/20 bg-white/5 backdrop-blur shadow-inner text-center font-mono">
                            <span class="text-xs uppercase text-slate-400 block tracking-widest font-sans">Single Booking Cap</span>
                            <span class="text-2xl font-extrabold text-[#3A9F9F] mt-1 block">$500 Max</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Support (Span 5) -->
                <div class="md:col-span-5 p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md hover:border-slate-200 transition-all duration-300 flex flex-col justify-between group">
                    <div class="space-y-4">
                        <div class="w-10 h-10 bg-[#3A9F9F]/10 rounded-lg flex items-center justify-center text-[#3A9F9F] group-hover:scale-105 transition-transform duration-300">
                            <!-- SVG Support Icon -->
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0F172A]">24/7 travel support</h3>
                        <p class="text-[#64748B] text-sm leading-relaxed font-light">
                            Our expert support team is always just one tap away for your travelers, anywhere in the world.
                        </p>
                    </div>

                    <!-- Chat Mock visual -->
                    <div class="mt-8 flex items-center space-x-3 bg-slate-50 p-4 border border-slate-100 rounded-xl">
                        <div class="relative">
                            <span class="absolute bottom-0 right-0 w-2.5 h-2.5 bg-emerald-500 rounded-full border-2 border-white"></span>
                            <div class="w-9 h-9 rounded-full bg-slate-300 flex items-center justify-center text-[#0F172A] font-bold text-xs">CS</div>
                        </div>
                        <div class="flex-1 bg-white p-2.5 rounded-lg border border-slate-100 shadow-sm text-[11px] text-[#64748B]">
                            "We're here to assist. Flight updated!"
                        </div>
                    </div>
                </div>

                <!-- Card 4: Analytics (Span 7) -->
                <div class="md:col-span-7 p-8 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md hover:border-slate-200 transition-all duration-300 flex flex-col justify-between group">
                    <div class="space-y-4">
                        <div class="w-10 h-10 bg-[#3A9F9F]/10 rounded-lg flex items-center justify-center text-[#3A9F9F] group-hover:scale-105 transition-transform duration-300">
                            <!-- SVG Analytics Icon -->
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0F172A]">Real-time reporting</h3>
                        <p class="text-[#64748B] text-sm leading-relaxed font-light">
                            Unify all your travel spend in a single dashboard. Track carbon impact, hotel savings, and airline performance with granular accuracy.
                        </p>
                    </div>

                    <!-- Total Savings Dashboard Block -->
                    <div class="mt-8 bg-slate-50 p-4 border border-slate-100 rounded-xl flex items-center justify-between">
                        <div>
                            <span class="text-[9px] uppercase tracking-wider font-bold text-[#64748B]">Total Monthly Savings</span>
                            <span class="text-xl font-black text-[#0F172A] block mt-1">+$12,450.00</span>
                        </div>
                        <div class="w-16 h-8 flex items-end justify-between space-x-1">
                            <span class="w-2.5 h-4 bg-slate-200 rounded-sm"></span>
                            <span class="w-2.5 h-6 bg-slate-200 rounded-sm"></span>
                            <span class="w-2.5 h-5 bg-slate-200 rounded-sm"></span>
                            <span class="w-2.5 h-8 bg-[#3A9F9F] rounded-sm"></span>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- Solutions Showcase Section -->
    <section id="showcase" class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-6">
            
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                <!-- Left: Dashboard Mock -->
                <div class="relative order-2 lg:order-1">
                    <div class="absolute -inset-2 bg-gradient-to-r from-indigo-500/10 to-[#3A9F9F]/10 rounded-2xl blur-xl opacity-60"></div>
                    <div class="relative bg-white border border-slate-100 rounded-2xl shadow-xl overflow-hidden">
                        <!-- Top header of search screen -->
                        <div class="p-4 border-b border-slate-50 bg-slate-50/50 flex justify-between items-center">
                            <span class="text-xs font-bold text-[#0F172A]">Enterprise Portal</span>
                            <span class="text-[10px] text-slate-400 font-mono">Platform Admin</span>
                        </div>
                        
                        <!-- Main Panel content -->
                        <div class="p-6 space-y-6">
                            <div class="flex justify-between items-center pb-4 border-b border-slate-50">
                                <div>
                                    <h4 class="text-xs uppercase text-slate-400 tracking-wider">Active Employees Travel</h4>
                                    <p class="text-base font-extrabold text-[#0F172A] mt-0.5">8 Live Bookings</p>
                                </div>
                                <span class="bg-[#3A9F9F]/10 text-[#3A9F9F] border border-[#3A9F9F]/10 text-[10px] font-bold uppercase px-2 py-0.5 rounded">All Clear</span>
                            </div>

                            <!-- List of corporate listings -->
                            <div class="space-y-3">
                                <div class="flex items-center justify-between p-3 border border-slate-100 rounded-lg hover:border-slate-200 transition-colors">
                                    <span class="text-xs font-semibold text-slate-800">Sarah Jenkins (Paris)</span>
                                    <span class="text-[10px] text-[#64748B]">Hotel &bull; In Policy</span>
                                </div>
                                <div class="flex items-center justify-between p-3 border border-slate-100 rounded-lg hover:border-slate-200 transition-colors">
                                    <span class="text-xs font-semibold text-slate-800">Mark Thompson (New York)</span>
                                    <span class="text-[10px] text-[#64748B]">Flight &bull; Auto Claimed</span>
                                </div>
                                <div class="flex items-center justify-between p-3 border border-slate-100 rounded-lg hover:border-slate-200 transition-colors">
                                    <span class="text-xs font-semibold text-slate-800">Aria Patel (London)</span>
                                    <span class="text-[10px] text-[#64748B]">Train &bull; In Policy</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Content & List -->
                <div class="space-y-8 order-1 lg:order-2">
                    <div class="space-y-4">
                        <span class="text-xs font-bold uppercase tracking-widest text-[#3A9F9F]">SCALING LOGISTICS</span>
                        <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0F172A] tracking-tight">
                            Scale your travel culture without losing sleep.
                        </h2>
                    </div>

                    <!-- Features list -->
                    <div class="space-y-6">
                        <!-- Item 1 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-6 h-6 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center font-bold text-xs shrink-0 mt-1">&check;</div>
                            <div>
                                <h3 class="text-base font-bold text-[#0F172A]">Centralized Visibility</h3>
                                <p class="text-sm text-[#64748B] mt-1 font-light">
                                    Know exactly where your travelers are at all times with our real-time duty-of-care dashboard.
                                </p>
                            </div>
                        </div>

                        <!-- Item 2 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-6 h-6 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center font-bold text-xs shrink-0 mt-1">&check;</div>
                            <div>
                                <h3 class="text-base font-bold text-[#0F172A]">AI Policy Automation</h3>
                                <p class="text-sm text-[#64748B] mt-1 font-light">
                                    Our AI engine automatically flags unusual spending patterns before they impact your quarterly budget.
                                </p>
                            </div>
                        </div>

                        <!-- Item 3 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-6 h-6 rounded-full bg-[#3A9F9F]/10 text-[#3A9F9F] flex items-center justify-center font-bold text-xs shrink-0 mt-1">&check;</div>
                            <div>
                                <h3 class="text-base font-bold text-[#0F172A]">One-Click Expensing</h3>
                                <p class="text-sm text-[#64748B] mt-1 font-light">
                                    Seamlessly sync every transaction with your existing ERP and accounting systems.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- CTA -->
                    <div class="pt-4">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3 font-semibold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow transition-all hover:-translate-y-0.5 duration-200">
                            Start Managing Better
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- Call To Action Section -->
    <section class="py-20 bg-slate-900 text-white relative overflow-hidden border-t border-slate-800">
        <!-- background blur decor -->
        <div class="absolute -right-20 -top-20 w-80 h-80 bg-[#3A9F9F]/10 rounded-full filter blur-3xl"></div>
        <div class="absolute -left-20 -bottom-20 w-80 h-80 bg-indigo-500/10 rounded-full filter blur-3xl"></div>

        <div class="max-w-4xl mx-auto px-6 text-center space-y-8 relative z-10">
            <h2 class="text-3xl sm:text-5xl font-extrabold tracking-tight leading-tight">
                Ready to transform your <br class="hidden sm:inline">
                travel program?
            </h2>
            <p class="text-slate-400 text-base max-w-xl mx-auto font-light leading-relaxed">
                Join thousands of companies using Aviaj to power their corporate logistics with precision and ease.
            </p>
            <div class="flex flex-col sm:flex-row justify-center gap-4 pt-2">
                <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200">
                    Request a free demo
                </a>
                <a href="#features" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-transparent hover:bg-white/5 border border-white/20 rounded-lg transition-all duration-200">
                    See pricing
                </a>
            </div>
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
                    <!-- Social placeholder badges -->
                    <div class="flex space-x-3 pt-2">
                        <a href="https://github.com/manjot/aviaj" class="w-8 h-8 rounded-full border border-slate-200 hover:border-[#3A9F9F] hover:text-[#3A9F9F] flex items-center justify-center text-[#64748B] transition-all">
                            <span class="font-bold text-xs">GH</span>
                        </a>
                    </div>
                </div>

                <!-- Product Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Product</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#features" class="hover:text-[#0F172A] transition-colors">Travel</a></li>
                        <li><a href="#features" class="hover:text-[#0F172A] transition-colors">Expense</a></li>
                        <li><a href="#features" class="hover:text-[#0F172A] transition-colors">Cards</a></li>
                        <li><a href="#features" class="hover:text-[#0F172A] transition-colors">Integrations</a></li>
                    </ul>
                </div>

                <!-- Solutions Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Solutions</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Travel Managers</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Finance Teams</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Travelers</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Executive Assts</a></li>
                    </ul>
                </div>

                <!-- Company Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Company</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">About Us</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Careers</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Sustainability</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Press</a></li>
                    </ul>
                </div>

                <!-- Legal Links -->
                <div class="col-span-1 md:col-span-2 space-y-4">
                    <h5 class="text-xs font-extrabold uppercase tracking-widest text-[#0F172A]">Legal</h5>
                    <ul class="space-y-2 text-xs text-[#64748B] font-light">
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Privacy Policy</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Terms of Service</a></li>
                        <li><a href="#showcase" class="hover:text-[#0F172A] transition-colors">Security</a></li>
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