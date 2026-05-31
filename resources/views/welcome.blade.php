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
    <section class="relative pt-32 pb-20 lg:pt-40 lg:pb-28 bg-[#FFFFFF] overflow-hidden" x-data="{ selectedOptions: [1, 2] }">
        <!-- Curved accent background on the right side -->
        <div class="absolute right-0 top-0 h-full w-[45%] bg-[#F8F9FF] rounded-l-[160px] hidden lg:block -z-10"></div>

        <div class="max-w-7xl mx-auto px-6 relative z-10">
            <div class="grid lg:grid-cols-12 gap-16 items-center">
                
                <!-- Left Column: Content & Grid Selector -->
                <div class="lg:col-span-6 space-y-8 text-left">
                    <!-- G2 Rating Star Badge -->
                    <div class="flex items-center space-x-2">
                        <!-- Custom G2 stylized logo -->
                        <span class="font-extrabold text-slate-800 text-sm tracking-tight flex items-center">G<span class="text-xs font-semibold text-slate-500 mr-1">²</span></span>
                        
                        <!-- Purple / Indigo star ratings -->
                        <div class="flex space-x-0.5">
                            <svg class="w-3.5 h-3.5 text-[#59BABA] fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                            <svg class="w-3.5 h-3.5 text-[#59BABA] fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                            <svg class="w-3.5 h-3.5 text-[#59BABA] fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                            <svg class="w-3.5 h-3.5 text-[#59BABA] fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                            <svg class="w-3.5 h-3.5 text-[#59BABA] fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        </div>
                        <span class="text-slate-500 text-xs font-medium">4.7 out of 5 &nbsp;|&nbsp; 9K+ reviews</span>
                    </div>

                    <!-- Main Title -->
                    <h1 class="text-4xl sm:text-5xl lg:text-[54px] font-extrabold tracking-tight text-[#161233] leading-[1.1] font-sans">
                        Business travel & expense<br>
                        management. Solved.
                    </h1>

                    <!-- Subtitle (Translated from Navan to Aviaj as requested) -->
                    <p class="text-lg text-slate-700 font-medium">
                        What would you like to do with Aviaj?
                    </p>

                    <!-- Interactive Grid Selector Checkboxes -->
                    <div class="space-y-3 max-w-xl">
                        <!-- Row 1: Two cards (each taking 50% width) -->
                        <div class="grid grid-cols-2 gap-3">
                            <!-- Card 1 -->
                            <div @click="selectedOptions.includes(1) ? selectedOptions = selectedOptions.filter(x => x !== 1) : selectedOptions.push(1)"
                                 :class="selectedOptions.includes(1) ? 'border-[#59BABA] bg-[#F5FBFB]' : 'border-transparent bg-[#F2F4FE] hover:bg-[#EBEDFA]'"
                                 class="relative border p-6 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[145px] text-center select-none group">
                                
                                <!-- Checkbox top-left -->
                                <div class="absolute top-4 left-4 w-4 h-4 rounded border flex items-center justify-center transition-all duration-200"
                                     :class="selectedOptions.includes(1) ? 'border-[#59BABA] bg-[#59BABA] text-white' : 'border-slate-300 bg-white group-hover:border-slate-400'">
                                    <svg x-show="selectedOptions.includes(1)" class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                
                                <!-- Icon of Airplane -->
                                <svg class="w-9 h-9 text-[#161233] mb-3 transition-transform duration-200 group-hover:scale-105" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
                                </svg>
                                
                                <span class="text-sm font-semibold text-[#161233] leading-tight">Create a company<br>travel program</span>
                            </div>

                            <!-- Card 2 -->
                            <div @click="selectedOptions.includes(2) ? selectedOptions = selectedOptions.filter(x => x !== 2) : selectedOptions.push(2)"
                                 :class="selectedOptions.includes(2) ? 'border-[#59BABA] bg-[#F5FBFB]' : 'border-transparent bg-[#F2F4FE] hover:bg-[#EBEDFA]'"
                                 class="relative border p-6 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[145px] text-center select-none group">
                                
                                <!-- Checkbox top-left -->
                                <div class="absolute top-4 left-4 w-4 h-4 rounded border flex items-center justify-center transition-all duration-200"
                                     :class="selectedOptions.includes(2) ? 'border-[#59BABA] bg-[#59BABA] text-white' : 'border-slate-300 bg-white group-hover:border-slate-400'">
                                    <svg x-show="selectedOptions.includes(2)" class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                
                                <!-- Icon of Credit Card -->
                                <svg class="w-9 h-9 text-[#161233] mb-3 transition-transform duration-200 group-hover:scale-105" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                                    <rect width="20" height="14" x="2" y="5" rx="2" />
                                    <line x1="2" x2="22" y1="10" y2="10" />
                                </svg>
                                
                                <span class="text-sm font-semibold text-[#161233] leading-tight">Manage company<br>cards & expenses</span>
                            </div>
                        </div>

                        <!-- Row 2: Three cards (each taking 33% width) -->
                        <div class="grid grid-cols-3 gap-3">
                            <!-- Card 3 -->
                            <div @click="selectedOptions.includes(3) ? selectedOptions = selectedOptions.filter(x => x !== 3) : selectedOptions.push(3)"
                                 :class="selectedOptions.includes(3) ? 'border-[#59BABA] bg-[#F5FBFB]' : 'border-transparent bg-[#F2F4FE] hover:bg-[#EBEDFA]'"
                                 class="relative border p-4 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[110px] text-center select-none group">
                                
                                <!-- Checkbox top-center -->
                                <div class="absolute top-3 inset-x-0 mx-auto w-4 h-4 rounded border flex items-center justify-center transition-all duration-200"
                                     :class="selectedOptions.includes(3) ? 'border-[#59BABA] bg-[#59BABA] text-white' : 'border-slate-300 bg-white group-hover:border-slate-400'">
                                    <svg x-show="selectedOptions.includes(3)" class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                
                                <span class="text-xs font-semibold text-[#161233] mt-5 leading-tight">Arrange a<br>team offsite</span>
                            </div>

                            <!-- Card 4 -->
                            <div @click="selectedOptions.includes(4) ? selectedOptions = selectedOptions.filter(x => x !== 4) : selectedOptions.push(4)"
                                 :class="selectedOptions.includes(4) ? 'border-[#59BABA] bg-[#F5FBFB]' : 'border-transparent bg-[#F2F4FE] hover:bg-[#EBEDFA]'"
                                 class="relative border p-4 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[110px] text-center select-none group">
                                
                                <!-- Checkbox top-center -->
                                <div class="absolute top-3 inset-x-0 mx-auto w-4 h-4 rounded border flex items-center justify-center transition-all duration-200"
                                     :class="selectedOptions.includes(4) ? 'border-[#59BABA] bg-[#59BABA] text-white' : 'border-slate-300 bg-white group-hover:border-slate-400'">
                                    <svg x-show="selectedOptions.includes(4)" class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                
                                <span class="text-xs font-semibold text-[#161233] mt-5 leading-tight">Book trips for<br>employees & execs</span>
                            </div>

                            <!-- Card 5 -->
                            <div @click="selectedOptions.includes(5) ? selectedOptions = selectedOptions.filter(x => x !== 5) : selectedOptions.push(5)"
                                 :class="selectedOptions.includes(5) ? 'border-[#59BABA] bg-[#F5FBFB]' : 'border-transparent bg-[#F2F4FE] hover:bg-[#EBEDFA]'"
                                 class="relative border p-4 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[110px] text-center select-none group">
                                
                                <!-- Checkbox top-center -->
                                <div class="absolute top-3 inset-x-0 mx-auto w-4 h-4 rounded border flex items-center justify-center transition-all duration-200"
                                     :class="selectedOptions.includes(5) ? 'border-[#59BABA] bg-[#59BABA] text-white' : 'border-slate-300 bg-white group-hover:border-slate-400'">
                                    <svg x-show="selectedOptions.includes(5)" class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                                </div>
                                
                                <span class="text-xs font-semibold text-[#161233] mt-5 leading-tight">Book my own<br>work trip</span>
                            </div>
                        </div>
                    </div>

                    <!-- Get Started Purple Capsule & Watch Demo -->
                    <div class="pt-2 flex flex-col items-start space-y-4">
                        <a href="{{ route('demo-login') }}" class="inline-flex items-center justify-center px-10 py-3.5 font-extrabold text-white bg-[#59BABA] hover:bg-[#48A5A5] rounded-full shadow-lg shadow-[#59BABA]/25 hover:shadow-xl hover:-translate-y-0.5 transition-all duration-200 min-w-[200px] text-center text-sm tracking-wide">
                            Get started
                        </a>
                        
                        <div class="pl-4">
                            <a href="#" class="text-xs font-bold text-[#161233] hover:text-[#59BABA] underline underline-offset-4 decoration-2 transition-colors">
                                Watch a demo video
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Premium Image & Dynamic Floating Cards -->
                <div class="lg:col-span-6 relative mt-12 lg:mt-0 flex justify-center">
                    
                    <!-- Main image container with highly rounded corners -->
                    <div class="relative w-full max-w-[460px] aspect-[4/5] rounded-[36px] overflow-hidden shadow-2xl border border-slate-100">
                        <img src="https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&q=80&w=800" 
                             alt="Corporate team working and walking together" 
                             class="w-full h-full object-cover">
                        <div class="absolute inset-0 bg-gradient-to-t from-slate-900/10 to-transparent"></div>
                    </div>

                    <!-- Floating Card A: Travel Policy details (top-left overlay) -->
                    <div class="absolute -top-6 -left-8 bg-white border border-slate-100/80 p-5 rounded-2xl shadow-[0_20px_40px_rgba(0,0,0,0.08)] w-[260px] space-y-3.5 z-20 transition-transform duration-300 hover:-translate-y-1 hover:shadow-2xl">
                        <div class="flex justify-between items-center">
                            <span class="text-[9px] font-extrabold uppercase text-white bg-[#59BABA] px-2 py-0.5 rounded tracking-wider">
                                Business
                            </span>
                        </div>
                        
                        <div>
                            <h4 class="text-2xl font-black text-[#161233] tracking-tight leading-none">LAX &rarr; SYD</h4>
                            <div class="flex items-center space-x-1 mt-1 text-slate-400">
                                <span class="w-1.5 h-1.5 rounded-full bg-slate-400"></span>
                                <span class="text-[10px] font-bold tracking-tight">United UA 839</span>
                            </div>
                        </div>

                        <div class="border-t border-slate-100"></div>

                        <div class="space-y-2">
                            <div class="flex justify-between items-center text-xs">
                                <div>
                                    <span class="text-[10px] font-bold text-slate-400 block uppercase leading-none">Business</span>
                                    <span class="text-sm font-extrabold text-slate-800">$1,439</span>
                                </div>
                                <span class="text-[9px] font-bold text-slate-400 border border-slate-200 rounded px-1.5 py-0.5 flex items-center space-x-1">
                                    <svg class="w-2.5 h-2.5 mr-0.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                                    <span>Out-of-Policy</span>
                                </span>
                            </div>
                            
                            <div class="flex justify-between items-center text-xs">
                                <div>
                                    <span class="text-[10px] font-bold text-slate-400 block uppercase leading-none">Economy</span>
                                    <span class="text-sm font-extrabold text-slate-800">$873</span>
                                </div>
                                <span class="text-[9px] font-bold text-[#59BABA] border border-[#59BABA]/20 bg-[#59BABA]/5 rounded px-1.5 py-0.5 flex items-center space-x-1">
                                    <svg class="w-2.5 h-2.5 mr-0.5 text-[#59BABA]" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                                    <span>In-Policy</span>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Floating Card B: Success Expense status (bottom-left overlay) -->
                    <div class="absolute -bottom-6 -left-4 bg-white border border-slate-100/80 px-4 py-3 rounded-2xl shadow-[0_15px_30px_rgba(0,0,0,0.06)] flex items-center space-x-3 z-30 transition-transform duration-300 hover:-translate-y-1 hover:shadow-xl max-w-[270px]">
                        <div class="w-9 h-9 rounded-xl bg-[#59BABA] flex items-center justify-center text-white font-black text-sm shadow-sm shadow-[#59BABA]/30">
                            A
                        </div>
                        <div class="leading-tight">
                            <span class="text-xs font-black text-slate-900 block">Success!</span>
                            <span class="text-[10px] text-slate-400 font-bold block">Expense submitted. You're done.</span>
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
                        <a href="{{ route('expense-management') }}" class="inline-flex items-center space-x-2 text-xs font-bold text-[#3A9F9F] hover:text-[#3A9F9F]/80 transition-colors">
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

                </div>
            </div>

        </div>
    </footer>

</body>
</html>
