<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aviaj | Corporate Travel, Expense & Cards Platform</title>
    
    <!-- Premium Typography & Styling -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="font-sans text-brand-900 bg-brand-50 selection:bg-brand-200 antialiased overflow-x-hidden">

    <!-- Premium Glassmorphic Header -->
    <header class="fixed top-0 inset-x-0 z-50 transition-all duration-300 border-b border-brand-200/50 bg-white/70 backdrop-blur-md">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <!-- Brand Logo -->
            <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold tracking-tight text-brand-950 font-sans">
                <span class="bg-gradient-to-r from-brand-600 to-indigo-600 bg-clip-text text-transparent">AVIAJ</span>
                <span class="text-xs uppercase px-2 py-0.5 rounded-full bg-brand-100 text-brand-700 tracking-wider">Navan Style</span>
            </a>

            <!-- Navigation Links -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-brand-700">
                <a href="#travel" class="hover:text-brand-950 transition-colors">Business Travel</a>
                <a href="#expense" class="hover:text-brand-950 transition-colors">Expense Claims</a>
                <a href="#cards" class="hover:text-brand-950 transition-colors">Corporate Cards</a>
                <a href="#why-aviaj" class="hover:text-brand-950 transition-colors">Why Aviaj</a>
            </nav>

            <!-- Action Buttons -->
            <div class="flex items-center space-x-4">
                <a href="{{ route('dashboard') }}" class="hidden sm:inline-flex items-center justify-center font-semibold text-brand-800 hover:text-brand-950 transition-colors">Sign In</a>
                <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-6 py-3 font-semibold text-white bg-gradient-to-r from-brand-700 to-indigo-700 rounded-xl hover:from-brand-800 hover:to-indigo-800 shadow-md shadow-brand-600/10 hover:shadow-lg hover:shadow-brand-600/20 active:scale-98 transition-all">
                    Launch Demo
                </a>
            </div>
        </div>
    </header>

    <!-- Interactive Hero Section -->
    <section class="relative pt-40 pb-24 lg:pt-48 lg:pb-36 bg-gradient-to-b from-white via-brand-50/30 to-brand-50">
        <!-- Floating Ambient Background Orbs -->
        <div class="absolute top-1/4 left-10 w-96 h-96 bg-brand-200/40 rounded-full mix-blend-multiply filter blur-3xl opacity-60 animate-pulse"></div>
        <div class="absolute top-1/3 right-10 w-96 h-96 bg-indigo-200/30 rounded-full mix-blend-multiply filter blur-3xl opacity-60 animate-pulse" style="animation-delay: 2s;"></div>

        <div class="max-w-7xl mx-auto px-6 relative z-10">
            <div class="grid lg:grid-cols-12 gap-16 items-center">
                <!-- Left: Engaging Pitch -->
                <div class="lg:col-span-7 text-center lg:text-left space-y-8">
                    <!-- Premium Pill -->
                    <div class="inline-flex items-center space-x-2 px-3 py-1 rounded-full bg-brand-100/80 border border-brand-200/50 text-brand-800 text-sm font-semibold">
                        <span class="flex h-2 w-2 rounded-full bg-indigo-600"></span>
                        <span>Enterprise Travel & Expense Re-engineered</span>
                    </div>

                    <h1 class="text-4xl sm:text-6xl font-extrabold tracking-tight text-brand-950 font-sans leading-none">
                        Manage all company travel, cards & expense. <br class="hidden sm:inline">
                        <span class="bg-gradient-to-r from-brand-600 via-indigo-600 to-violet-600 bg-clip-text text-transparent">All in one platform.</span>
                    </h1>

                    <p class="text-lg sm:text-xl text-brand-700 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-light">
                        Aviaj unifies corporate booking, virtual spending cards, and rapid reimbursement workflows to save companies hours of accounting and thousands in overhead.
                    </p>

                    <!-- CTAs -->
                    <div class="flex flex-col sm:flex-row justify-center lg:justify-start gap-4">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-8 py-4 font-bold text-white bg-brand-950 hover:bg-brand-900 rounded-2xl shadow-xl shadow-brand-950/20 active:scale-98 transition-all">
                            Enter Corporate Dashboard
                        </a>
                        <a href="#why-aviaj" class="inline-flex items-center justify-center px-8 py-4 font-bold text-brand-800 hover:text-brand-950 bg-white hover:bg-brand-100/50 border border-brand-200 rounded-2xl shadow-sm active:scale-98 transition-all">
                            See Features
                        </a>
                    </div>

                    <!-- Trust Stats -->
                    <div class="pt-8 border-t border-brand-200/80 grid grid-cols-3 gap-6 max-w-lg mx-auto lg:mx-0">
                        <div>
                            <div class="text-3xl font-extrabold text-brand-950">98%</div>
                            <div class="text-xs uppercase text-brand-500 font-bold tracking-wider mt-1">Satisfaction</div>
                        </div>
                        <div>
                            <div class="text-3xl font-extrabold text-brand-950">&lt;60s</div>
                            <div class="text-xs uppercase text-brand-500 font-bold tracking-wider mt-1">Expensing</div>
                        </div>
                        <div>
                            <div class="text-3xl font-extrabold text-brand-950">30%</div>
                            <div class="text-xs uppercase text-brand-500 font-bold tracking-wider mt-1">Savings</div>
                        </div>
                    </div>
                </div>

                <!-- Right: Graphic Preview / Showcase -->
                <div class="lg:col-span-5 relative">
                    <!-- Glassmorphic Mockup Container -->
                    <div class="relative bg-white/80 p-6 rounded-3xl border border-brand-200/50 shadow-2xl shadow-brand-950/10 backdrop-blur-lg">
                        
                        <!-- Top Decor: Mock Browser Window Buttons -->
                        <div class="flex space-x-1.5 pb-4 border-b border-brand-100">
                            <span class="w-3 h-3 bg-red-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-yellow-400 rounded-full"></span>
                            <span class="w-3 h-3 bg-green-400 rounded-full"></span>
                        </div>

                        <!-- Content Mockup: Corporate Cards -->
                        <div class="space-y-6 pt-4">
                            <div class="flex justify-between items-center">
                                <span class="text-xs font-bold uppercase text-brand-500 tracking-wide">AVIAJ VIRTUAL CARDS</span>
                                <span class="px-2 py-0.5 bg-green-100 text-green-700 text-xs font-bold rounded-full">Active</span>
                            </div>

                            <!-- Interactive Card Preview -->
                            <div class="bg-gradient-to-br from-brand-900 to-indigo-950 text-white p-6 rounded-2xl shadow-lg relative overflow-hidden">
                                <!-- Wave Decor -->
                                <div class="absolute -right-10 -bottom-10 w-40 h-40 bg-indigo-500/10 rounded-full filter blur-xl"></div>
                                
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="text-[10px] text-brand-300 font-bold uppercase tracking-wider">Company Travel Card</p>
                                        <h3 class="text-lg font-bold tracking-wide mt-1">Acme Corp</h3>
                                    </div>
                                    <div class="text-xl font-black italic tracking-tighter">VISA</div>
                                </div>
                                <div class="mt-8">
                                    <p class="text-lg font-mono tracking-widest">•••• •••• •••• 8824</p>
                                </div>
                                <div class="mt-4 flex justify-between items-end">
                                    <div>
                                        <p class="text-[9px] text-brand-400 uppercase tracking-widest">Cardholder</p>
                                        <p class="text-xs font-semibold">Sarah Jenkins</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-[9px] text-brand-400 uppercase tracking-widest">Expires</p>
                                        <p class="text-xs font-semibold">08/30</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Live Transaction Stream Preview -->
                            <div class="space-y-3">
                                <p class="text-xs font-bold uppercase text-brand-500 tracking-wide">Recent Transactions</p>
                                
                                <div class="flex justify-between items-center p-3 bg-brand-50/80 border border-brand-100 rounded-xl">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 bg-indigo-100 text-indigo-700 flex items-center justify-center rounded-lg font-bold text-xs">U</div>
                                        <div>
                                            <p class="text-xs font-bold text-brand-950">Uber Ride</p>
                                            <p class="text-[10px] text-brand-500">Travel &bull; Approved</p>
                                        </div>
                                    </div>
                                    <span class="text-xs font-bold text-brand-950">-$42.50</span>
                                </div>

                                <div class="flex justify-between items-center p-3 bg-brand-50/80 border border-brand-100 rounded-xl">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 bg-emerald-100 text-emerald-700 flex items-center justify-center rounded-lg font-bold text-xs">R</div>
                                        <div>
                                            <p class="text-xs font-bold text-brand-950">The Ritz-Carlton, SFO</p>
                                            <p class="text-[10px] text-brand-500">Lodging &bull; Pending</p>
                                        </div>
                                    </div>
                                    <span class="text-xs font-bold text-brand-950">-$1,200.00</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Product Features Section -->
    <section id="why-aviaj" class="py-20 bg-white border-y border-brand-200/50">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center max-w-3xl mx-auto mb-16 space-y-4">
                <h2 class="text-xs font-bold uppercase tracking-widest text-indigo-600">UNIFIED POWER</h2>
                <h3 class="text-3xl sm:text-4xl font-extrabold text-brand-950 tracking-tight font-sans">
                    Everything you need to travel, track, and reimburse.
                </h3>
                <p class="text-brand-600 font-light">
                    Built by design professionals to integrate seamlessly with your company culture and operations.
                </p>
            </div>

            <div class="grid md:grid-cols-3 gap-8">
                <!-- Feature 1 -->
                <div id="travel" class="p-8 rounded-3xl bg-brand-50 hover:bg-brand-100/50 border border-brand-200/50 shadow-sm transition-all duration-300 group">
                    <div class="w-12 h-12 bg-brand-950 text-white rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                        <!-- Plane Icon -->
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/></svg>
                    </div>
                    <h4 class="text-xl font-bold text-brand-950 mt-6">Corporate Travel Booking</h4>
                    <p class="text-brand-600 font-light text-sm mt-3 leading-relaxed">
                        Search flights, premium hotels, and car rentals. Benefit from enterprise discounted rates and structured approval workflows tailored for scaling corporate teams.
                    </p>
                </div>

                <!-- Feature 2 -->
                <div id="expense" class="p-8 rounded-3xl bg-brand-50 hover:bg-brand-100/50 border border-brand-200/50 shadow-sm transition-all duration-300 group">
                    <div class="w-12 h-12 bg-indigo-600 text-white rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                        <!-- Receipt Icon -->
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 14l2 2 4-4m-6 2h.01M12 20h.01M15 20h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <h4 class="text-xl font-bold text-brand-950 mt-6">Automated Expense Claims</h4>
                    <p class="text-brand-600 font-light text-sm mt-3 leading-relaxed">
                        Submit expenses easily with receipt mock uploads. Managers receive real-time notifications to review, audit, and click-to-approve pending expense claims.
                    </p>
                </div>

                <!-- Feature 3 -->
                <div id="cards" class="p-8 rounded-3xl bg-brand-50 hover:bg-brand-100/50 border border-brand-200/50 shadow-sm transition-all duration-300 group">
                    <div class="w-12 h-12 bg-violet-600 text-white rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                        <!-- Credit Card Icon -->
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                    </div>
                    <h4 class="text-xl font-bold text-brand-950 mt-6">Smart Corporate Cards</h4>
                    <p class="text-brand-600 font-light text-sm mt-3 leading-relaxed">
                        Generate and distribute instant virtual payment cards with built-in spending limits. Track company outflows live from a unified billing ledger.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-12 bg-brand-950 text-brand-300">
        <div class="max-w-7xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-6">
            <div>
                <a href="/" class="text-2xl font-black tracking-tight text-white">AVIAJ</a>
                <p class="text-sm text-brand-400 mt-2">&copy; 2026 Aviaj Inc. All rights reserved. Premium Navan Clone.</p>
            </div>
            <div class="flex space-x-6 text-sm text-brand-400">
                <a href="{{ route('demo-login') }}" class="hover:text-white transition-colors">Enter Demo App</a>
                <a href="https://github.com/manjot/aviaj" class="hover:text-white transition-colors">GitHub Repository</a>
            </div>
        </div>
    </footer>

</body>
</html>
