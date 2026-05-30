<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajath Infotech | Custom Mobile App Development Company in Dubai, UAE</title>
    <meta name="description" content="Ajath Infotech is the leading custom mobile app development company in Dubai, Abu Dhabi, & UAE. We build premium iOS, Android, AI-powered & hybrid mobile apps.">
    
    <!-- Premium Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Tailwind and App JS -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <!-- Extra visual overrides for ultimate premium feel -->
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        h1, h2, h3, h4, .font-heading {
            font-family: 'Outfit', sans-serif;
        }
        /* Custom smooth scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #F8F9FF;
        }
        ::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        /* Glassmorphism utility */
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(199, 196, 216, 0.3);
        }
        .glass-dark {
            background: rgba(11, 28, 48, 0.85);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        /* Custom glow animation */
        @keyframes float {
            0%, 100% { transform: translateY(0px) scale(1); }
            50% { transform: translateY(-10px) scale(1.02); }
        }
        .animate-float {
            animation: float 6s ease-in-out infinite;
        }
    </style>
</head>
<body class="bg-[#F8F9FF] text-[#464555] antialiased overflow-x-hidden" x-data="{ mobileMenuOpen: false }">

    <!-- Glowing Background Ambient Blurs -->
    <div class="absolute top-0 right-0 w-[600px] sm:w-[800px] h-[600px] sm:h-[800px] bg-[#DAE2FD] rounded-full filter blur-[100px] sm:blur-[150px] opacity-40 pointer-events-none -z-10 translate-x-1/3 -translate-y-1/3"></div>
    <div class="absolute top-[1800px] left-0 w-[400px] sm:w-[600px] h-[400px] sm:h-[600px] bg-purple-200 rounded-full filter blur-[80px] sm:blur-[120px] opacity-30 pointer-events-none -z-10 -translate-x-1/3"></div>
    <div class="absolute bottom-[800px] right-0 w-[500px] h-[500px] bg-indigo-200 rounded-full filter blur-[100px] opacity-30 pointer-events-none -z-10"></div>

    <!-- Top Navigation Bar -->
    <header class="fixed top-0 inset-x-0 z-50 transition-all duration-300 border-b border-slate-200/50 bg-white/85 backdrop-blur-md">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <!-- Brand Logo -->
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

            <!-- Navigation Links (Desktop) -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-[#464555]">
                <a href="#services" class="hover:text-[#3525CD] transition-colors">Services</a>
                <a href="#portfolio" class="hover:text-[#3525CD] transition-colors">Portfolio</a>
                <a href="#why-choose-us" class="hover:text-[#3525CD] transition-colors">Why Us</a>
                <a href="#process" class="hover:text-[#3525CD] transition-colors">Process</a>
                <a href="#faq" class="hover:text-[#3525CD] transition-colors">FAQ</a>
            </nav>

            <!-- Action Button (Desktop) -->
            <div class="hidden md:flex items-center">
                <a href="#lead-form" class="inline-flex items-center justify-center px-6 py-3 font-semibold text-white bg-gradient-to-r from-[#4F46E5] to-[#A855F7] rounded-full shadow-lg shadow-indigo-600/10 hover:shadow-indigo-600/25 hover:scale-[1.02] active:scale-98 transition-all">
                    Get Free Consultation
                </a>
            </div>

            <!-- Hamburger Button (Mobile) -->
            <button @click="mobileMenuOpen = !mobileMenuOpen" class="md:hidden p-2 rounded-lg text-[#0B1C30] hover:bg-slate-100 transition-all focus:outline-none" aria-label="Toggle Menu">
                <svg x-show="!mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
                <svg x-show="mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="display: none;">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>

        <!-- Mobile Navigation Menu Dropdown -->
        <div x-show="mobileMenuOpen" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0 -translate-y-4" x-transition:enter-end="opacity-100 translate-y-0" x-transition:leave="transition ease-in duration-150" x-transition:leave-start="opacity-100 translate-y-0" x-transition:leave-end="opacity-0 -translate-y-4" class="md:hidden bg-white/95 border-b border-slate-200 shadow-xl" style="display: none;">
            <div class="px-6 py-6 space-y-4 font-semibold text-[#464555]">
                <a @click="mobileMenuOpen = false" href="#services" class="block py-2 hover:text-[#3525CD] transition-colors border-b border-slate-100">Services</a>
                <a @click="mobileMenuOpen = false" href="#portfolio" class="block py-2 hover:text-[#3525CD] transition-colors border-b border-slate-100">Portfolio</a>
                <a @click="mobileMenuOpen = false" href="#why-choose-us" class="block py-2 hover:text-[#3525CD] transition-colors border-b border-slate-100">Why Us</a>
                <a @click="mobileMenuOpen = false" href="#process" class="block py-2 hover:text-[#3525CD] transition-colors border-b border-slate-100">Process</a>
                <a @click="mobileMenuOpen = false" href="#faq" class="block py-2 hover:text-[#3525CD] transition-colors border-b border-slate-100">FAQ</a>
                <a @click="mobileMenuOpen = false" href="#lead-form" class="inline-flex w-full items-center justify-center px-6 py-3 font-semibold text-white bg-gradient-to-r from-[#4F46E5] to-[#A855F7] rounded-xl shadow-lg mt-4">
                    Get Free Consultation
                </a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="relative pt-32 pb-20 lg:pt-40 lg:pb-28">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-12 gap-12 items-center">
                <!-- Left: Hero Text & Badges -->
                <div class="lg:col-span-7 space-y-6 lg:space-y-8 text-center lg:text-left">
                    <!-- Clutch Rating Badge -->
                    <div class="inline-flex items-center space-x-2 px-4 py-1.5 rounded-full bg-[#DAE2FD] border border-indigo-100/60 text-[#3525CD] text-sm font-semibold shadow-sm">
                        <!-- Tiny Star SVGs -->
                        <div class="flex space-x-0.5 text-amber-500">
                            <svg class="w-3.5 h-3.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                        </div>
                        <span>4.8/5 Clutch rating • 500+ Reviews</span>
                    </div>

                    <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-[#0B1C30] leading-tight">
                        Custom Mobile App <br class="hidden sm:inline">
                        <span class="bg-gradient-to-r from-[#3525CD] to-[#6B00B7] bg-clip-text text-transparent">Development in UAE</span>
                    </h1>

                    <p class="text-base sm:text-lg lg:text-xl text-[#464555] max-w-2xl mx-auto lg:mx-0 leading-relaxed font-light">
                        We build scalable iOS, Android & AI-powered mobile apps for startups and enterprises in Dubai, Abu Dhabi & across the UAE.
                    </p>

                    <!-- CTAs -->
                    <div class="flex flex-col sm:flex-row justify-center lg:justify-start gap-4 pt-2">
                        <a href="#lead-form" class="inline-flex items-center justify-center px-8 py-4 font-bold text-white bg-gradient-to-r from-[#4F46E5] to-[#A855F7] rounded-xl shadow-xl shadow-indigo-600/10 hover:shadow-indigo-600/25 hover:scale-[1.02] transition-all">
                            Get Free Consultation
                        </a>
                        <a href="#portfolio" class="inline-flex items-center justify-center px-8 py-4 font-bold text-[#0B1C30] bg-white hover:bg-slate-50 border border-slate-200 rounded-xl shadow-sm hover:scale-[1.02] transition-all">
                            Request Quote
                        </a>
                    </div>

                    <!-- Client Platform Mockup Visual -->
                    <div class="pt-8 opacity-90 hidden lg:block animate-float">
                        <div class="relative max-w-lg overflow-hidden rounded-2xl border border-slate-200 bg-white/70 backdrop-blur-md shadow-2xl p-6">
                            <div class="flex justify-between items-center border-b border-slate-100 pb-3 mb-4">
                                <span class="text-xs font-bold text-[#3525CD] uppercase tracking-wider">Active UAE Pipeline</span>
                                <div class="flex space-x-1.5">
                                    <span class="w-2.5 h-2.5 bg-red-400 rounded-full"></span>
                                    <span class="w-2.5 h-2.5 bg-yellow-400 rounded-full"></span>
                                    <span class="w-2.5 h-2.5 bg-green-400 rounded-full"></span>
                                </div>
                            </div>
                            <div class="space-y-3">
                                <div class="flex justify-between items-center p-3 bg-slate-50/80 rounded-xl border border-slate-100">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 rounded-lg bg-indigo-50 flex items-center justify-center text-indigo-700 font-bold text-sm">ET</div>
                                        <div>
                                            <p class="text-xs font-bold text-[#0B1C30]">Emirates Tech Logistics App</p>
                                            <p class="text-[10px] text-slate-500">Dubai Logistics &bull; React Native</p>
                                        </div>
                                    </div>
                                    <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold">V1.4 Live</span>
                                </div>
                                <div class="flex justify-between items-center p-3 bg-slate-50/80 rounded-xl border border-slate-100">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-8 h-8 rounded-lg bg-purple-50 flex items-center justify-center text-purple-700 font-bold text-sm">DB</div>
                                        <div>
                                            <p class="text-xs font-bold text-[#0B1C30]">Dubai Banking Smart Wallet</p>
                                            <p class="text-[10px] text-slate-500">Corporate Finance &bull; Swift iOS</p>
                                        </div>
                                    </div>
                                    <span class="px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[10px] font-bold">In Audit</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Glassmorphic Lead Capture Form -->
                <div class="lg:col-span-5" id="lead-form">
                    <div class="glass-card p-8 rounded-3xl shadow-2xl relative overflow-hidden border border-slate-200/60">
                        <div class="absolute -top-10 -right-10 w-24 h-24 bg-indigo-500/10 rounded-full filter blur-xl"></div>
                        <h3 class="text-2xl font-bold text-[#0B1C30] tracking-tight">Ready to Start?</h3>
                        <p class="text-sm text-[#464555] mt-1 mb-6">Get a detailed proposal within 24 hours.</p>

                        <form class="space-y-4" x-data="{ submitted: false }" @submit.prevent="submitted = true">
                            <div x-show="!submitted" class="space-y-4">
                                <div>
                                    <label class="block text-xs font-bold text-[#0B1C30] uppercase tracking-wider mb-1">Name</label>
                                    <input type="text" placeholder="Your Name" required class="w-full px-4 py-3 rounded-lg border border-slate-200/80 focus:border-[#3525CD] focus:ring-1 focus:ring-[#3525CD] bg-white/90 text-sm outline-none transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-[#0B1C30] uppercase tracking-wider mb-1">Company</label>
                                    <input type="text" placeholder="Company Name" required class="w-full px-4 py-3 rounded-lg border border-slate-200/80 focus:border-[#3525CD] focus:ring-1 focus:ring-[#3525CD] bg-white/90 text-sm outline-none transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-[#0B1C30] uppercase tracking-wider mb-1">Email Address</label>
                                    <input type="email" placeholder="email@company.com" required class="w-full px-4 py-3 rounded-lg border border-slate-200/80 focus:border-[#3525CD] focus:ring-1 focus:ring-[#3525CD] bg-white/90 text-sm outline-none transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-[#0B1C30] uppercase tracking-wider mb-1">Phone / WhatsApp</label>
                                    <input type="tel" placeholder="+971 50 XXX XXXX" required class="w-full px-4 py-3 rounded-lg border border-slate-200/80 focus:border-[#3525CD] focus:ring-1 focus:ring-[#3525CD] bg-white/90 text-sm outline-none transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-[#0B1C30] uppercase tracking-wider mb-1">Project Budget (AED)</label>
                                    <select class="w-full px-4 py-3 rounded-lg border border-slate-200/80 focus:border-[#3525CD] focus:ring-1 focus:ring-[#3525CD] bg-white/90 text-sm outline-none transition-all">
                                        <option>AED 15,000 - 30,000</option>
                                        <option>AED 30,000 - 50,000</option>
                                        <option>AED 50,000 - 100,000</option>
                                        <option>AED 100,000+</option>
                                    </select>
                                </div>
                                <button type="submit" class="w-full py-4 text-center text-sm font-bold text-white bg-gradient-to-r from-[#3525CD] to-[#6B00B7] rounded-xl hover:from-[#4F46E5] hover:to-[#A855F7] shadow-lg shadow-indigo-600/15 hover:shadow-xl hover:scale-[1.01] transition-all">
                                    Send Proposal Request
                                </button>
                                <p class="text-[11px] text-center text-slate-500 mt-2">We respect your privacy. All inquiries are covered by NDA.</p>
                            </div>

                            <div x-show="submitted" class="text-center py-10 space-y-4" style="display: none;">
                                <div class="w-16 h-16 bg-emerald-100 text-emerald-600 flex items-center justify-center rounded-full mx-auto">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                <h4 class="text-xl font-bold text-[#0B1C30]">Thank you!</h4>
                                <p class="text-sm text-slate-600 leading-relaxed">Your proposal request was received successfully. A consultant will reach out via email / WhatsApp within 24 hours.</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Social Proof Section -->
    <section class="py-12 bg-white border-y border-slate-200/50">
        <div class="max-w-7xl mx-auto px-6">
            <h2 class="text-center text-xs font-bold text-slate-400 uppercase tracking-widest mb-8">TRUSTED BY LEADING ENTERPRISES ACROSS UAE</h2>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-8 items-center justify-items-center opacity-70">
                <!-- Emirates Tech -->
                <div class="flex items-center space-x-2 hover:opacity-100 transition-opacity duration-300">
                    <div class="w-8 h-8 bg-indigo-500/10 flex items-center justify-center rounded-lg text-[#3525CD] font-bold text-xs">ET</div>
                    <span class="font-heading font-black text-sm text-[#0B1C30]">EMIRATES TECH</span>
                </div>
                <!-- Dubai Banking -->
                <div class="flex items-center space-x-2 hover:opacity-100 transition-opacity duration-300">
                    <div class="w-8 h-8 bg-purple-500/10 flex items-center justify-center rounded-lg text-[#6B00B7] font-bold text-xs">DB</div>
                    <span class="font-heading font-black text-sm text-[#0B1C30]">DUBAI BANKING</span>
                </div>
                <!-- Gulf Retail -->
                <div class="flex items-center space-x-2 hover:opacity-100 transition-opacity duration-300">
                    <div class="w-8 h-8 bg-indigo-500/10 flex items-center justify-center rounded-lg text-[#4F46E5] font-bold text-xs">GR</div>
                    <span class="font-heading font-black text-sm text-[#0B1C30]">GULF RETAIL</span>
                </div>
                <!-- Healthcare DXB -->
                <div class="flex items-center space-x-2 hover:opacity-100 transition-opacity duration-300">
                    <div class="w-8 h-8 bg-slate-500/10 flex items-center justify-center rounded-lg text-slate-700 font-bold text-xs">HD</div>
                    <span class="font-heading font-black text-sm text-[#0B1C30]">HEALTHCARE DXB</span>
                </div>
                <!-- Abu Dhabi VC -->
                <div class="flex items-center space-x-2 hover:opacity-100 transition-opacity duration-300 col-span-2 md:col-span-1">
                    <div class="w-8 h-8 bg-indigo-500/10 flex items-center justify-center rounded-lg text-[#3525CD] font-bold text-xs">AD</div>
                    <span class="font-heading font-black text-sm text-[#0B1C30]">ABU DHABI VC</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Bento Grid Section -->
    <section id="services" class="py-20 lg:py-28">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center max-w-3xl mx-auto mb-16 space-y-4">
                <span class="text-xs font-bold uppercase tracking-widest text-[#3525CD] bg-indigo-50 border border-indigo-100 px-3 py-1 rounded-full">Expertise</span>
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0B1C30] tracking-tight">
                    Comprehensive App Solutions
                </h2>
                <p class="text-slate-500 font-light">
                    End-to-end development expertise tailored for the Middle Eastern market dynamics.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- iOS Card -->
                <div class="bg-white p-8 rounded-3xl border border-slate-100 hover:shadow-2xl hover:shadow-indigo-600/5 group hover:-translate-y-1 transition-all duration-300 relative overflow-hidden flex flex-col justify-between h-80">
                    <div>
                        <div class="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-[#3525CD] mb-6 group-hover:scale-110 transition-transform">
                            <!-- iOS Icon -->
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0B1C30] mb-3">iOS Development</h3>
                        <p class="text-sm leading-relaxed text-slate-500 font-light">
                            Premium, high-performance iPhone and iPad apps built with Swift for the elite UAE audience.
                        </p>
                    </div>
                    <a href="#lead-form" class="inline-flex items-center text-sm font-semibold text-[#3525CD] group-hover:translate-x-1 transition-transform mt-4">
                        Explore <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                    </a>
                </div>

                <!-- Android Card -->
                <div class="bg-white p-8 rounded-3xl border border-slate-100 hover:shadow-2xl hover:shadow-indigo-600/5 group hover:-translate-y-1 transition-all duration-300 relative overflow-hidden flex flex-col justify-between h-80">
                    <div>
                        <div class="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-[#3525CD] mb-6 group-hover:scale-110 transition-transform">
                            <!-- Android Icon -->
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 18h.01M9 16h6m-3-12a9 9 0 019 9v3a3 3 0 01-3 3H9a3 3 0 01-3-3v-3a9 9 0 019-9z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0B1C30] mb-3">Android Development</h3>
                        <p class="text-sm leading-relaxed text-slate-500 font-light">
                            Scalable and robust Kotlin-based applications optimized for the diverse Android ecosystem.
                        </p>
                    </div>
                    <a href="#lead-form" class="inline-flex items-center text-sm font-semibold text-[#3525CD] group-hover:translate-x-1 transition-transform mt-4">
                        Explore <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                    </a>
                </div>

                <!-- Ecommerce card -->
                <div class="bg-white p-8 rounded-3xl border border-slate-100 hover:shadow-2xl hover:shadow-indigo-600/5 group hover:-translate-y-1 transition-all duration-300 relative overflow-hidden flex flex-col justify-between h-80">
                    <div>
                        <div class="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-[#3525CD] mb-6 group-hover:scale-110 transition-transform">
                            <!-- Shop Icon -->
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0B1C30] mb-3">Ecommerce Excellence</h3>
                        <p class="text-sm leading-relaxed text-slate-500 font-light">
                            Custom M-commerce solutions with local payment gateways (Telr, Checkout.com, Stripe) and Arabic support.
                        </p>
                    </div>
                    <a href="#lead-form" class="inline-flex items-center text-sm font-semibold text-[#3525CD] group-hover:translate-x-1 transition-transform mt-4">
                        Get Pricing <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                    </a>
                </div>

                <!-- Cross-Platform -->
                <div class="bg-white p-8 rounded-3xl border border-slate-100 hover:shadow-2xl hover:shadow-indigo-600/5 group hover:-translate-y-1 transition-all duration-300 relative overflow-hidden flex flex-col justify-between h-80">
                    <div>
                        <div class="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-[#3525CD] mb-6 group-hover:scale-110 transition-transform">
                            <!-- Code Icon -->
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#0B1C30] mb-3">Cross-Platform</h3>
                        <p class="text-sm leading-relaxed text-slate-500 font-light">
                            Save 40% on costs with Flutter or React Native without compromising on native feel.
                        </p>
                    </div>
                    <a href="#lead-form" class="inline-flex items-center text-sm font-semibold text-[#3525CD] group-hover:translate-x-1 transition-transform mt-4">
                        Get Quote <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                    </a>
                </div>

                <!-- AI App Development Card -->
                <div class="md:col-span-2 bg-[#0B1C30] text-white p-8 rounded-3xl hover:shadow-2xl hover:shadow-indigo-950/20 group hover:-translate-y-1 transition-all duration-300 relative overflow-hidden flex flex-col justify-between h-80">
                    <!-- Tech decoration grid lines -->
                    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(79,70,229,0.15),transparent_60%)]"></div>
                    <div>
                        <div class="w-12 h-12 rounded-xl bg-[#3525CD] flex items-center justify-center text-white mb-6 group-hover:scale-110 transition-transform relative z-10">
                            <!-- Sparkle Icon -->
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/></svg>
                        </div>
                        <h3 class="text-xl font-bold text-white mb-3 relative z-10">AI-Powered Apps</h3>
                        <p class="text-sm leading-relaxed text-indigo-150 font-light relative z-10 max-w-xl">
                            Integrate Generative AI, predictive analytics, and LLMs into your mobile ecosystem. Build the next generation of smart solutions for Dubai's tech hubs.
                        </p>
                    </div>
                    <a href="#lead-form" class="inline-flex items-center text-sm font-semibold text-[#A855F7] group-hover:translate-x-1 transition-transform mt-4 relative z-10">
                        Learn More <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Portfolio Section -->
    <section id="portfolio" class="py-20 lg:py-28 bg-[#F0F2FA]/50 border-y border-slate-200/40">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center max-w-3xl mx-auto mb-16 space-y-4">
                <span class="text-xs font-bold uppercase tracking-widest text-[#3525CD] bg-indigo-50 border border-indigo-100 px-3 py-1 rounded-full">Success stories</span>
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0B1C30] tracking-tight">
                    Industry-Specific Success
                </h2>
                <p class="text-slate-500 font-light">
                    Real metrics that demonstrate how we scale business operations through customized mobile engineering.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Case Study 1 -->
                <div class="bg-white rounded-3xl overflow-hidden border border-slate-100 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between">
                    <div>
                        <!-- Colored top border accent -->
                        <div class="h-2 bg-gradient-to-r from-blue-500 to-indigo-500"></div>
                        <div class="p-8">
                            <div class="flex justify-between items-center mb-4">
                                <span class="px-3 py-1 text-[10px] font-bold uppercase rounded-full bg-slate-100 text-slate-600">BUSINESS</span>
                                <span class="text-xs text-slate-400">Ajath SaaS</span>
                            </div>
                            <h3 class="text-xl font-bold text-[#0B1C30] mb-3">Corporate SaaS Hub</h3>
                            <p class="text-sm text-slate-500 font-light leading-relaxed mb-6">
                                A unified platform for enterprise resource management and secure communications built for scale.
                            </p>
                        </div>
                    </div>
                    <div class="px-8 pb-8 pt-4 border-t border-slate-100 bg-slate-50/50 grid grid-cols-2 gap-4 text-center">
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">30%</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">USER ENGAGEMENT</span>
                        </div>
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">12 Wks</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">GO-TO-MARKET</span>
                        </div>
                    </div>
                </div>

                <!-- Case Study 2 -->
                <div class="bg-white rounded-3xl overflow-hidden border border-slate-100 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between">
                    <div>
                        <!-- Colored top border accent -->
                        <div class="h-2 bg-gradient-to-r from-purple-500 to-pink-500"></div>
                        <div class="p-8">
                            <div class="flex justify-between items-center mb-4">
                                <span class="px-3 py-1 text-[10px] font-bold uppercase rounded-full bg-purple-50 text-[#6B00B7]">MARKETING</span>
                                <span class="text-xs text-slate-400">Ajath Social</span>
                            </div>
                            <h3 class="text-xl font-bold text-[#0B1C30] mb-3">GrowthMark DXB</h3>
                            <p class="text-sm text-slate-500 font-light leading-relaxed mb-6">
                                Influencer marketing platform with real-time ROI tracking and campaign delivery analytics.
                            </p>
                        </div>
                    </div>
                    <div class="px-8 pb-8 pt-4 border-t border-slate-100 bg-slate-50/50 grid grid-cols-2 gap-4 text-center">
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">500k+</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">DOWNLOADS</span>
                        </div>
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">4.9</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">STORE RATING</span>
                        </div>
                    </div>
                </div>

                <!-- Case Study 3 -->
                <div class="bg-white rounded-3xl overflow-hidden border border-slate-100 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between">
                    <div>
                        <!-- Colored top border accent -->
                        <div class="h-2 bg-gradient-to-r from-teal-400 to-emerald-500"></div>
                        <div class="p-8">
                            <div class="flex justify-between items-center mb-4">
                                <span class="px-3 py-1 text-[10px] font-bold uppercase rounded-full bg-emerald-50 text-emerald-700">IOT / TECH</span>
                                <span class="text-xs text-slate-400">Ajath Hardware</span>
                            </div>
                            <h3 class="text-xl font-bold text-[#0B1C30] mb-3">SmartConnect UAE</h3>
                            <p class="text-sm text-slate-500 font-light leading-relaxed mb-6">
                                IoT-integrated home automation and security app customized for the Middle East climate and grids.
                            </p>
                        </div>
                    </div>
                    <div class="px-8 pb-8 pt-4 border-t border-slate-100 bg-slate-50/50 grid grid-cols-2 gap-4 text-center">
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">25%</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">ENERGY SAVINGS</span>
                        </div>
                        <div>
                            <span class="block text-2xl font-black text-[#3525CD]">99.9%</span>
                            <span class="text-[9px] uppercase font-bold text-slate-400 tracking-wider">UPTIME</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose Us / Comparison Section -->
    <section id="why-choose-us" class="py-20 lg:py-28 bg-white">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                <!-- Left: Value Props -->
                <div class="space-y-8">
                    <div class="space-y-4">
                        <span class="text-xs font-bold uppercase tracking-widest text-[#3525CD] bg-indigo-50 border border-indigo-100 px-3 py-1 rounded-full">Why Ajath Infotech?</span>
                        <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0B1C30] tracking-tight">
                            Engineering Growth for the UAE Landscape
                        </h2>
                        <p class="text-slate-500 font-light leading-relaxed">
                            We don't just build apps; we architect digital outcomes. Here is how we separate our deliveries from outsourced generic models.
                        </p>
                    </div>

                    <div class="space-y-6">
                        <!-- Prop 1 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 rounded-full bg-indigo-50 border border-indigo-100 flex items-center justify-center text-[#3525CD] shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
                            </div>
                            <div>
                                <h4 class="font-bold text-[#0B1C30] text-lg">Arabic & English Expertise</h4>
                                <p class="text-sm text-slate-500 font-light mt-1">
                                    UI/UX designed explicitly for native right-to-left (RTL) Arabic and left-to-right (LTR) English interfaces.
                                </p>
                            </div>
                        </div>

                        <!-- Prop 2 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 rounded-full bg-indigo-50 border border-indigo-100 flex items-center justify-center text-[#3525CD] shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                            </div>
                            <div>
                                <h4 class="font-bold text-[#0B1C30] text-lg">Local Compliance & Security</h4>
                                <p class="text-sm text-slate-500 font-light mt-1">
                                    Strict adherence to UAE's strict data protection regulations, TRA guidelines, and secure cloud storage limits.
                                </p>
                            </div>
                        </div>

                        <!-- Prop 3 -->
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 rounded-full bg-indigo-50 border border-indigo-100 flex items-center justify-center text-[#3525CD] shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                            </div>
                            <div>
                                <h4 class="font-bold text-[#0B1C30] text-lg">Full NDA Protection</h4>
                                <p class="text-sm text-slate-500 font-light mt-1">
                                    Your ideas, proprietary software code, and enterprise architecture are legally protected from day one.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Comparison Table -->
                <div class="glass-card rounded-3xl shadow-xl overflow-hidden border border-slate-200 bg-slate-50/50">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-[#0B1C30] text-white">
                                <th class="p-6 text-sm font-bold tracking-wider uppercase">Features</th>
                                <th class="p-6 text-sm font-bold tracking-wider uppercase">Others</th>
                                <th class="p-6 text-sm font-bold tracking-wider uppercase bg-[#3525CD]">Ajath</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200/60 text-sm text-[#464555]">
                            <tr>
                                <td class="p-6 font-semibold text-[#0B1C30]">Delivery Timeline</td>
                                <td class="p-6">Delayed / Inconsistent</td>
                                <td class="p-6 font-semibold text-[#3525CD] bg-indigo-50/30">On-time Sprints</td>
                            </tr>
                            <tr>
                                <td class="p-6 font-semibold text-[#0B1C30]">Development Type</td>
                                <td class="p-6">Generic Templates</td>
                                <td class="p-6 font-semibold text-[#3525CD] bg-indigo-50/30">Custom Architecture</td>
                            </tr>
                            <tr>
                                <td class="p-6 font-semibold text-[#0B1C30]">Post-Launch Support</td>
                                <td class="p-6">Chargeable Hourly</td>
                                <td class="p-6 font-semibold text-[#3525CD] bg-indigo-50/30">3-Month Free Warranty</td>
                            </tr>
                            <tr>
                                <td class="p-6 font-semibold text-[#0B1C30]">UAE Market Focus</td>
                                <td class="p-6">Outsourced Generic</td>
                                <td class="p-6 font-semibold text-[#3525CD] bg-indigo-50/30">Local Experts</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>

    <!-- Proven App Delivery Process -->
    <section id="process" class="py-20 lg:py-28 bg-[#F8F9FF] border-t border-slate-200/40">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center max-w-3xl mx-auto mb-16 space-y-4">
                <span class="text-xs font-bold uppercase tracking-widest text-[#3525CD] bg-indigo-50 border border-indigo-100 px-3 py-1 rounded-full">Workflow</span>
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0B1C30] tracking-tight">
                    Our Proven App Delivery Process
                </h2>
                <p class="text-slate-500 font-light">
                    An agile five-stage blueprint ensuring transparency and rigorous code auditing at each cycle.
                </p>
            </div>

            <!-- Horizontal steps wrapper (Stacks on mobile) -->
            <div class="relative grid grid-cols-1 md:grid-cols-5 gap-8 pt-8">
                <!-- Timeline progress bar (Desktop only) -->
                <div class="absolute top-[52px] left-[10%] right-[10%] h-0.5 bg-indigo-100 hidden md:block -z-10"></div>

                <!-- Step 1 -->
                <div class="text-center group space-y-4">
                    <div class="w-16 h-16 rounded-full bg-white border-4 border-indigo-500/20 group-hover:border-[#3525CD] flex items-center justify-center font-bold text-xl text-[#3525CD] shadow-md mx-auto transition-colors duration-300 bg-white z-10 relative">
                        01
                    </div>
                    <h3 class="font-bold text-[#0B1C30] text-lg">Discovery Call</h3>
                    <p class="text-xs text-slate-500 leading-relaxed font-light px-2">
                        Understanding your vision and business goals.
                    </p>
                </div>

                <!-- Step 2 -->
                <div class="text-center group space-y-4">
                    <div class="w-16 h-16 rounded-full bg-white border-4 border-indigo-500/20 group-hover:border-[#3525CD] flex items-center justify-center font-bold text-xl text-[#3525CD] shadow-md mx-auto transition-colors duration-300 bg-white z-10 relative">
                        02
                    </div>
                    <h3 class="font-bold text-[#0B1C30] text-lg">UI/UX Design</h3>
                    <p class="text-xs text-slate-500 leading-relaxed font-light px-2">
                        High-fidelity prototypes and native user flows.
                    </p>
                </div>

                <!-- Step 3 -->
                <div class="text-center group space-y-4">
                    <div class="w-16 h-16 rounded-full bg-white border-4 border-indigo-500/20 group-hover:border-[#3525CD] flex items-center justify-center font-bold text-xl text-[#3525CD] shadow-md mx-auto transition-colors duration-300 bg-white z-10 relative">
                        03
                    </div>
                    <h3 class="font-bold text-[#0B1C30] text-lg">Development</h3>
                    <p class="text-xs text-slate-500 leading-relaxed font-light px-2">
                        Agile sprint-by-sprint coding with regular builds.
                    </p>
                </div>

                <!-- Step 4 -->
                <div class="text-center group space-y-4">
                    <div class="w-16 h-16 rounded-full bg-white border-4 border-indigo-500/20 group-hover:border-[#3525CD] flex items-center justify-center font-bold text-xl text-[#3525CD] shadow-md mx-auto transition-colors duration-300 bg-white z-10 relative">
                        04
                    </div>
                    <h3 class="font-bold text-[#0B1C30] text-lg">Testing</h3>
                    <p class="text-xs text-slate-500 leading-relaxed font-light px-2">
                        Rigorous QA on 50+ actual iPhone & Android devices.
                    </p>
                </div>

                <!-- Step 5 -->
                <div class="text-center group space-y-4">
                    <div class="w-16 h-16 rounded-full bg-white border-4 border-indigo-500/20 group-hover:border-[#3525CD] flex items-center justify-center font-bold text-xl text-[#3525CD] shadow-md mx-auto transition-colors duration-300 bg-white z-10 relative">
                        05
                    </div>
                    <h3 class="font-bold text-[#0B1C30] text-lg">Launch & Support</h3>
                    <p class="text-xs text-slate-500 leading-relaxed font-light px-2">
                        App Store submissions and 3-month free warranty.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing Guidance Section -->
    <section class="py-16 bg-[#0B1C30] text-white relative overflow-hidden">
        <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_bottom_left,rgba(79,70,229,0.2),transparent_50%)]"></div>
        <div class="max-w-4xl mx-auto px-6 text-center relative z-10 space-y-6">
            <h2 class="text-3xl sm:text-4xl font-extrabold tracking-tight">Investment Guidance</h2>
            <p class="text-indigo-200 max-w-xl mx-auto font-light leading-relaxed">
                Transparent pricing structures scaled for premium digital transformation in the UAE.
            </p>
            <div class="inline-flex flex-col items-center justify-center px-8 py-6 rounded-2xl bg-white/5 border border-white/10 backdrop-blur-md">
                <span class="text-xs font-semibold uppercase text-indigo-300 tracking-wider">App development starts from</span>
                <span class="text-4xl sm:text-5xl font-black text-white mt-2 mb-1">AED 15,000</span>
                <span class="text-[10px] text-indigo-200/70">Final estimate depends on custom architecture & APIs</span>
            </div>
            <p class="text-xs text-indigo-300/80 leading-relaxed max-w-md mx-auto">
                Need a specific breakdown? Get an accurate timeline & pricing overview customized for your business strategy.
            </p>
            <div class="pt-2">
                <a href="#lead-form" class="inline-flex items-center justify-center px-8 py-3.5 font-bold text-white bg-gradient-to-r from-[#4F46E5] to-[#A855F7] rounded-xl hover:scale-[1.02] shadow-xl shadow-indigo-500/10 transition-all">
                    Get Custom Estimate
                </a>
            </div>
        </div>
    </section>

    <!-- FAQs Section -->
    <section id="faq" class="py-20 lg:py-28 bg-white" x-data="{ activeFaq: null }">
        <div class="max-w-4xl mx-auto px-6">
            <div class="text-center mb-16 space-y-4">
                <span class="text-xs font-bold uppercase tracking-widest text-[#3525CD] bg-indigo-50 border border-indigo-100 px-3 py-1 rounded-full">Help Desk</span>
                <h2 class="text-3xl sm:text-4xl font-extrabold text-[#0B1C30] tracking-tight">
                    Frequently Asked Questions
                </h2>
            </div>

            <!-- Accordions Grid -->
            <div class="space-y-4">
                <!-- FAQ 1 -->
                <div class="border border-slate-100 rounded-2xl overflow-hidden bg-slate-50/50">
                    <button @click="activeFaq = activeFaq === 1 ? null : 1" class="w-full p-6 text-left flex justify-between items-center font-bold text-[#0B1C30] hover:text-[#3525CD] transition-colors focus:outline-none">
                        <span>How much does it cost to build an app in UAE?</span>
                        <svg class="w-5 h-5 transform transition-transform" :class="activeFaq === 1 ? 'rotate-180 text-[#3525CD]' : 'text-slate-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div x-show="activeFaq === 1" x-transition class="p-6 pt-0 text-sm text-slate-500 leading-relaxed font-light border-t border-slate-100 bg-white" style="display: none;">
                        Basic apps start around AED 15,000, while complex enterprise solutions or marketplace apps can range from AED 50,000 to AED 150,000+ depending on the feature set and platform requirements.
                    </div>
                </div>

                <!-- FAQ 2 -->
                <div class="border border-slate-100 rounded-2xl overflow-hidden bg-slate-50/50">
                    <button @click="activeFaq = activeFaq === 2 ? null : 2" class="w-full p-6 text-left flex justify-between items-center font-bold text-[#0B1C30] hover:text-[#3525CD] transition-colors focus:outline-none">
                        <span>How long does the development take?</span>
                        <svg class="w-5 h-5 transform transition-transform" :class="activeFaq === 2 ? 'rotate-180 text-[#3525CD]' : 'text-slate-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div x-show="activeFaq === 2" x-transition class="p-6 pt-0 text-sm text-slate-500 leading-relaxed font-light border-t border-slate-100 bg-white" style="display: none;">
                        Standard mobile applications typically take between 8 to 16 weeks to design, develop, test, and release, depending on the complexity of backend integrations, AI layers, and design specs.
                    </div>
                </div>

                <!-- FAQ 3 -->
                <div class="border border-slate-100 rounded-2xl overflow-hidden bg-slate-50/50">
                    <button @click="activeFaq = activeFaq === 3 ? null : 3" class="w-full p-6 text-left flex justify-between items-center font-bold text-[#0B1C30] hover:text-[#3525CD] transition-colors focus:outline-none">
                        <span>Do you sign an NDA before we share our idea?</span>
                        <svg class="w-5 h-5 transform transition-transform" :class="activeFaq === 3 ? 'rotate-180 text-[#3525CD]' : 'text-slate-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div x-show="activeFaq === 3" x-transition class="p-6 pt-0 text-sm text-slate-500 leading-relaxed font-light border-t border-slate-100 bg-white" style="display: none;">
                        Yes, absolutely. We secure all initial client briefs and corporate proprietary ideas under comprehensive NDA agreements before code scoping or architecture consulting.
                    </div>
                </div>

                <!-- FAQ 4 -->
                <div class="border border-slate-100 rounded-2xl overflow-hidden bg-slate-50/50">
                    <button @click="activeFaq = activeFaq === 4 ? null : 4" class="w-full p-6 text-left flex justify-between items-center font-bold text-[#0B1C30] hover:text-[#3525CD] transition-colors focus:outline-none">
                        <span>Do you provide post-launch maintenance?</span>
                        <svg class="w-5 h-5 transform transition-transform" :class="activeFaq === 4 ? 'rotate-180 text-[#3525CD]' : 'text-slate-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div x-show="activeFaq === 4" x-transition class="p-6 pt-0 text-sm text-slate-500 leading-relaxed font-light border-t border-slate-100 bg-white" style="display: none;">
                        We provide a 3-month free warranty covering all codebase repairs, crashes, and store listing stability audits. Beyond that, we support clients with dedicated SLA ongoing maintenance frameworks.
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Final CTA Section -->
    <section class="py-20 lg:py-28 bg-[#F0F2FA]/50 border-t border-slate-200/40 relative overflow-hidden">
        <!-- Glowing decoration blob -->
        <div class="absolute bottom-0 left-1/2 w-[600px] h-[300px] bg-purple-200 rounded-full filter blur-[120px] opacity-40 -translate-x-1/2 translate-y-1/2 pointer-events-none"></div>

        <div class="max-w-4xl mx-auto px-6 text-center space-y-8 relative z-10">
            <h2 class="text-3xl sm:text-5xl font-extrabold tracking-tight text-[#0B1C30] leading-tight">
                Ready to Build Your Mobile App in UAE?
            </h2>
            <p class="text-slate-500 max-w-xl mx-auto font-light leading-relaxed">
                Join 100+ successful businesses that chose Ajath Infotech for their digital transformation journey. Get an NDA-secured proposal.
            </p>
            <div class="flex flex-col sm:flex-row justify-center gap-4">
                <a href="#lead-form" class="inline-flex items-center justify-center px-8 py-4 font-bold text-white bg-gradient-to-r from-[#4F46E5] to-[#A855F7] rounded-xl shadow-xl shadow-indigo-600/10 hover:shadow-indigo-600/25 hover:scale-[1.02] transition-all">
                    Get Free Proposal
                </a>
                <a href="#lead-form" class="inline-flex items-center justify-center px-8 py-4 font-bold text-[#0B1C30] bg-white hover:bg-slate-50 border border-slate-200 rounded-xl shadow-sm hover:scale-[1.02] transition-all">
                    Schedule Consultation
                </a>
            </div>
        </div>
    </section>

    <!-- Local SEO Footer -->
    <footer class="py-16 bg-[#0B1C30] text-slate-400 border-t border-white/5 relative z-10">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-12 pb-12 border-b border-white/5">
                <!-- Branding Info -->
                <div class="space-y-4">
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
                    <p class="text-xs leading-relaxed font-light">
                        Leading Mobile App Development Company in Dubai, providing cutting-edge digital solutions across the UAE.
                    </p>
                    <div class="flex space-x-3 text-white/60">
                        <!-- Tiny Social SVGs / placeholders -->
                        <a href="https://github.com/manjot" class="hover:text-white transition-colors" aria-label="GitHub">
                            <svg class="w-5 h-5 fill-current" viewBox="0 0 24 24"><path d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482C19.138 20.197 22 16.44 22 12.017 22 6.484 17.522 2 12 2z"/></svg>
                        </a>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="space-y-4">
                    <h4 class="font-bold text-white text-sm tracking-wider uppercase">Quick Links</h4>
                    <ul class="space-y-2 text-xs font-light">
                        <li><a href="#services" class="hover:text-white transition-colors">Services</a></li>
                        <li><a href="#portfolio" class="hover:text-white transition-colors">Portfolio</a></li>
                        <li><a href="#why-choose-us" class="hover:text-white transition-colors">Industries</a></li>
                        <li><a href="#lead-form" class="hover:text-white transition-colors">Contact Us</a></li>
                    </ul>
                </div>

                <!-- Services Links -->
                <div class="space-y-4">
                    <h4 class="font-bold text-white text-sm tracking-wider uppercase">Services</h4>
                    <ul class="space-y-2 text-xs font-light">
                        <li><a href="#lead-form" class="hover:text-white transition-colors">iPhone App Development</a></li>
                        <li><a href="#lead-form" class="hover:text-white transition-colors">Android App Development</a></li>
                        <li><a href="#lead-form" class="hover:text-white transition-colors">Flutter Development</a></li>
                        <li><a href="#lead-form" class="hover:text-white transition-colors">AI & ML Solutions</a></li>
                    </ul>
                </div>

                <!-- UAE Office details -->
                <div class="space-y-4">
                    <h4 class="font-bold text-white text-sm tracking-wider uppercase">UAE Office</h4>
                    <div class="space-y-3 text-xs font-light leading-relaxed">
                        <div class="flex items-start space-x-2">
                            <!-- Pin SVG -->
                            <svg class="w-4 h-4 text-indigo-400 mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                            <span>Office no. 304, Floor no. 3, Coastal Building Al Qusais 2nd, Dubai - United Arab Emirates.</span>
                        </div>
                        <div class="flex items-center space-x-2">
                            <!-- Phone SVG -->
                            <svg class="w-4 h-4 text-indigo-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305.98a10.582 10.582 0 004.872 4.872l.98-1.305a1 1 0 01.988-.321l2.2.548a1 1 0 01.725.94V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                            <span>+971 50 431 3932</span>
                        </div>
                        <div class="flex items-center space-x-2">
                            <!-- Email SVG -->
                            <svg class="w-4 h-4 text-indigo-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                            <span>info@ajath.ae</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Copyright and legal -->
            <div class="flex flex-col sm:flex-row items-center justify-between pt-8 text-[11px] font-light text-slate-500 gap-4">
                <span>&copy; 2026 Ajath Infotech. All Rights Reserved. Dubai, UAE.</span>
                <div class="flex space-x-4">
                    <a href="#lead-form" class="hover:text-white transition-colors">Privacy Policy</a>
                    <a href="#lead-form" class="hover:text-white transition-colors">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Floating Interactive WhatsApp Button (Bottom Right) -->
    <a href="https://wa.me/971504313932?text=Hi%20Ajath%20Infotech,%20I'd%20like%2520to%2520discuss%2520a%2520mobile%2520app%2520development%2520project." target="_blank" class="fixed bottom-6 right-6 z-40 w-14 h-14 bg-[#25D366] hover:bg-[#128C7E] text-white rounded-full flex items-center justify-center shadow-2xl hover:scale-110 active:scale-95 transition-all duration-300" aria-label="Chat on WhatsApp">
        <!-- WhatsApp Icon SVG -->
        <svg class="w-8 h-8 fill-current" viewBox="0 0 24 24">
            <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.746.953 3.71 1.454 5.709 1.455h.008c6.56 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
        </svg>
    </a>

</body>
</html>
