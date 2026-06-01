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
<body class="font-sans text-[#0F172A] bg-[#FFFFFF] antialiased overflow-x-hidden selection:bg-[#59BABA]/20" x-data="{ showRewardsModal: false }">

    <!-- Premium Glassmorphic Navigation Bar -->
    <!-- Top Announcement Banner -->
    <div class="bg-[#214D4D] text-white py-2 px-4 text-xs font-semibold tracking-wide text-center relative z-50 flex items-center justify-center space-x-2">
        <!-- Gift Icon SVG -->
        <svg class="w-4 h-4 text-[#59BABA]" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
        </svg>
        <span>Get $500 for personal travel when your company joins Aviaj. <a href="#" @click.prevent="showRewardsModal = true" class="underline hover:text-[#59BABA] transition-colors ml-1">Learn more</a></span>
    </div>

    <header class="fixed top-8 inset-x-0 z-50 transition-all duration-300 border-b border-slate-100 bg-white/95 backdrop-blur-xl shadow-sm">
        <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
            <!-- Brand Logo matching shared Figma SVG exactly -->
            <a href="/" class="flex items-center space-x-2 transition-transform duration-300 hover:scale-102">
                <svg width="52" height="23" viewBox="0 0 52 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12.6797 17.3906L11.2148 13.1719H4.92188L3.45703 17.3906H0L6.02344 0.878906H10.1016L16.1016 17.3906H12.6797ZM8.8125 5.82422C8.71875 5.55078 8.62695 5.27539 8.53711 4.99805C8.44727 4.7207 8.36914 4.4668 8.30273 4.23633C8.23633 4.00586 8.18164 3.81641 8.13867 3.66797C8.0957 3.51953 8.07031 3.4375 8.0625 3.42188C8.05469 3.44531 8.03125 3.53125 7.99219 3.67969C7.95312 3.82812 7.90039 4.01562 7.83398 4.24219C7.76758 4.46875 7.68945 4.7207 7.59961 4.99805C7.50977 5.27539 7.41797 5.55078 7.32422 5.82422L5.69531 10.5703H10.4414L8.8125 5.82422ZM21.8648 14.7305L25.0406 4.71094H28.4859L23.8102 17.3906H19.8727L15.3375 4.71094H18.818L21.8648 14.7305ZM29.6672 2.42578V0H32.9602V2.42578H29.6672ZM29.6672 17.3906V4.71094H32.9602V17.3906H29.6672ZM38.6648 17.625C38.0555 17.625 37.5105 17.541 37.0301 17.373C36.5496 17.2051 36.1414 16.959 35.8055 16.6348C35.4695 16.3105 35.2117 15.9102 35.032 15.4336C34.8523 14.957 34.7625 14.4141 34.7625 13.8047C34.7625 13.0547 34.8934 12.4238 35.1551 11.9121C35.4168 11.4004 35.7742 10.9863 36.2273 10.6699C36.6805 10.3535 37.2117 10.123 37.8211 9.97852C38.4305 9.83398 39.0789 9.75781 39.7664 9.75L42.4969 9.70312V9.05859C42.4969 8.59766 42.4559 8.21289 42.3738 7.9043C42.2918 7.5957 42.1727 7.34375 42.0164 7.14844C41.8602 6.95312 41.6668 6.81445 41.4363 6.73242C41.2059 6.65039 40.9422 6.60938 40.6453 6.60938C40.3719 6.60938 40.1277 6.63672 39.9129 6.69141C39.698 6.74609 39.5125 6.8418 39.3563 6.97852C39.2 7.11523 39.073 7.29883 38.9754 7.5293C38.8777 7.75977 38.8094 8.05078 38.7703 8.40234L35.3367 8.23828C35.4305 7.68359 35.6023 7.17773 35.8523 6.7207C36.1023 6.26367 36.448 5.86719 36.8895 5.53125C37.3309 5.19531 37.8738 4.93555 38.5184 4.75195C39.1629 4.56836 39.9188 4.47656 40.7859 4.47656C41.575 4.47656 42.2781 4.57422 42.8953 4.76953C43.5125 4.96484 44.0359 5.25586 44.4656 5.64258C44.8953 6.0293 45.2234 6.50391 45.45 7.06641C45.6766 7.62891 45.7898 8.28125 45.7898 9.02344V13.6406C45.7898 13.9375 45.8035 14.2031 45.8309 14.4375C45.8582 14.6719 45.909 14.8691 45.9832 15.0293C46.0574 15.1895 46.1629 15.3105 46.2996 15.3926C46.4363 15.4746 46.6141 15.5156 46.8328 15.5156C47.0828 15.5156 47.325 15.4922 47.5594 15.4453V17.2266C47.3641 17.2734 47.1883 17.3164 47.032 17.3555C46.8758 17.3945 46.7195 17.4258 46.5633 17.4492C46.407 17.4727 46.241 17.4922 46.0652 17.5078C45.8895 17.5234 45.6844 17.5312 45.45 17.5312C44.6219 17.5312 44.0105 17.3281 43.616 16.9219C43.2215 16.5156 42.9852 15.918 42.907 15.1289H42.8367C42.3992 15.918 41.8387 16.5312 41.1551 16.9688C40.4715 17.4062 39.6414 17.625 38.6648 17.625ZM42.4969 11.5195L40.8094 11.543C40.4578 11.5586 40.1238 11.5879 39.8074 11.6309C39.491 11.6738 39.2137 11.7637 38.9754 11.9004C38.7371 12.0371 38.5477 12.2344 38.407 12.4922C38.2664 12.75 38.1961 13.1016 38.1961 13.5469C38.1961 14.1484 38.3348 14.5957 38.6121 14.8887C38.8895 15.1816 39.2586 15.3281 39.7195 15.3281C40.1414 15.3281 40.5242 15.2383 40.868 15.0586C41.2117 14.8789 41.5027 14.6426 41.741 14.3496C41.9793 14.0566 42.1648 13.7188 42.2977 13.3359C42.4305 12.9531 42.4969 12.5625 42.4969 12.1641V11.5195ZM48.4945 2.42578V0H51.7875V2.42578H48.4945ZM48.4242 22.3711C47.9867 22.3711 47.6059 22.3613 47.2816 22.3418C46.9574 22.3223 46.6742 22.2969 46.432 22.2656V19.9453C46.5336 19.9609 46.6352 19.9727 46.7367 19.9805C46.8383 19.9883 46.9359 19.9922 47.0297 19.9922C47.3344 19.9922 47.5805 19.9609 47.768 19.8984C47.9555 19.8359 48.1039 19.7305 48.2133 19.582C48.3227 19.4336 48.3969 19.2383 48.4359 18.9961C48.475 18.7539 48.4945 18.4531 48.4945 18.0938V4.71094H51.7875V18.8906C51.7875 19.3984 51.725 19.8633 51.6 20.2852C51.475 20.707 51.2777 21.0742 51.0082 21.3867C50.7387 21.6992 50.391 21.9414 49.9652 22.1133C49.5395 22.2852 49.0258 22.3711 48.4242 22.3711Z" fill="#59BABA"/>
                </svg>
            </a>

            <!-- Navigation Links matching screenshot exactly -->
            <nav class="hidden lg:flex items-center space-x-6 font-semibold text-xs tracking-wide text-slate-800">
                <a href="#travel" class="hover:text-[#59BABA] transition-colors relative">Platform</a>
                <a href="#expense" class="hover:text-[#59BABA] transition-colors relative">Solutions</a>
                <a href="#pricing" class="hover:text-[#59BABA] transition-colors relative">Pricing</a>
                <a href="#resources" class="hover:text-[#59BABA] transition-colors relative">Resources</a>
                <a href="#customers" class="hover:text-[#59BABA] transition-colors relative">Customers</a>
                <a href="#company" class="hover:text-[#59BABA] transition-colors relative">Company</a>
            </nav>

            <!-- Action Buttons matching screenshot exactly -->
            <div class="flex items-center space-x-3.5">
                <a href="{{ route('get-started') }}?source=Homepage" id="nav-get-started" class="hidden sm:inline-flex items-center justify-center px-4 py-2 font-bold text-white bg-[#59BABA] hover:bg-[#48A5A5] rounded-full text-xs transition-all duration-200">
                    Get started
                </a>
                <a href="#" id="nav-request-demo" class="hidden sm:inline-flex items-center justify-center px-4 py-2 font-bold border border-slate-900 rounded-full text-xs text-slate-900 hover:bg-slate-50 transition-all duration-200">
                    Request a demo
                </a>
                
                <!-- Log In with Flag Icon -->
                <a href="{{ route('dashboard') }}" id="nav-login" class="inline-flex items-center space-x-1 text-xs font-bold text-slate-800 hover:text-[#59BABA] transition-colors pl-2 border-l border-slate-200">
                    <span>Log In</span>
                    <!-- American Flag mini circle -->
                    <span class="w-3.5 h-3.5 rounded-full overflow-hidden flex items-center justify-center border border-slate-100 shadow-sm shrink-0">
                        <svg class="w-full h-full" viewBox="0 0 741 390" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect width="741" height="390" fill="#B22234"/>
                            <path d="M0 30h741M0 90h741M0 150h741M0 210h741M0 270h741M0 330h741" stroke="#FFF" stroke-width="30"/>
                            <rect width="296" height="210" fill="#3C3B6E"/>
                            <!-- standard US Flag star pattern simplified for high-fidelity mini look -->
                            <g fill="#FFF">
                                <circle cx="25" cy="20" r="4"/><circle cx="75" cy="20" r="4"/><circle cx="125" cy="20" r="4"/><circle cx="175" cy="20" r="4"/><circle cx="225" cy="20" r="4"/><circle cx="271" cy="20" r="4"/>
                                <circle cx="50" cy="40" r="4"/><circle cx="100" cy="40" r="4"/><circle cx="150" cy="40" r="4"/><circle cx="200" cy="40" r="4"/><circle cx="250" cy="40" r="4"/>
                                <circle cx="25" cy="60" r="4"/><circle cx="75" cy="60" r="4"/><circle cx="125" cy="60" r="4"/><circle cx="175" cy="60" r="4"/><circle cx="225" cy="60" r="4"/><circle cx="271" cy="60" r="4"/>
                                <circle cx="50" cy="80" r="4"/><circle cx="100" cy="80" r="4"/><circle cx="150" cy="80" r="4"/><circle cx="200" cy="80" r="4"/><circle cx="250" cy="80" r="4"/>
                                <circle cx="25" cy="100" r="4"/><circle cx="75" cy="100" r="4"/><circle cx="125" cy="100" r="4"/><circle cx="175" cy="100" r="4"/><circle cx="225" cy="100" r="4"/><circle cx="271" cy="100" r="4"/>
                            </g>
                        </svg>
                    </span>
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
                                 id="hero-card-travel" id="hero-card-expenses" class="relative border p-6 rounded-2xl cursor-pointer transition-all duration-200 flex flex-col items-center justify-center min-h-[145px] text-center select-none group">
                                
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
                        <a href="{{ route('get-started') }}?source=Homepage" class="inline-flex items-center justify-center px-10 py-3.5 font-extrabold text-white bg-[#59BABA] hover:bg-[#48A5A5] rounded-full shadow-lg shadow-[#59BABA]/25 hover:shadow-xl hover:-translate-y-0.5 transition-all duration-200 min-w-[200px] text-center text-sm tracking-wide">
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
                        <a href="{{ route('get-started') }}?source=Homepage" class="inline-flex items-center space-x-2 text-xs font-bold text-[#3A9F9F] hover:text-[#3A9F9F]/80 transition-colors">
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
                        <a href="{{ route('get-started') }}?source=Homepage" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
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
                        <a href="{{ route('get-started') }}?source=Homepage" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
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
                        <a href="{{ route('get-started') }}?source=Homepage" class="px-5 py-2.5 rounded-lg bg-white border border-slate-200 text-xs font-bold text-[#0F172A] shadow-sm hover:shadow transition-all">
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
                <a href="{{ route('get-started') }}?source=Homepage" class="inline-flex items-center justify-center px-6 py-3.5 font-bold text-white bg-[#3A9F9F] hover:bg-[#3A9F9F]/90 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200">
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
                    <a href="{{ route('get-started') }}?source=Homepage" class="hover:text-[#0F172A]">Enter Demo App</a>

                </div>
            </div>

        </div>
    </footer>


    <!-- Premium Exit Intent / Learn More Rewards Modal -->
    <div x-show="showRewardsModal" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0 scale-95"
         x-transition:enter-end="opacity-100 scale-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100 scale-100"
         x-transition:leave-end="opacity-0 scale-95"
         class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm"
         style="display: none;">
         
        <div class="relative max-w-4xl w-full bg-[#EBF0FF] rounded-[32px] overflow-hidden shadow-2xl grid md:grid-cols-12 border border-slate-100 p-2 transform transition-all"
             @click.away="showRewardsModal = false">
             
            <!-- Close Cross Button -->
            <button @click="showRewardsModal = false" class="absolute top-6 right-6 text-slate-400 hover:text-slate-800 transition-colors z-30 font-bold text-xl p-1 bg-white/80 hover:bg-white rounded-full">
                <svg class="w-5.5 h-5.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>

            <!-- Left Half: Rewards Information Form -->
            <div class="md:col-span-6 flex flex-col justify-between p-8 sm:p-12 space-y-6 text-left">
                <!-- Rewards Illustration Card -->
                <div class="flex justify-center md:justify-start">
                    <div class="relative w-44 h-24 bg-[#6F00FF] rounded-2xl flex flex-col justify-between p-3.5 shadow-lg transform rotate-[-4deg] border border-[#7C1AFF]/30">
                        <span class="text-[9px] font-black text-indigo-200 tracking-widest uppercase">AVIAJ</span>
                        <div class="flex justify-between items-end">
                            <span class="text-3xl font-black text-white leading-none">$500</span>
                            <span class="text-[9px] font-bold text-white bg-white/20 px-1.5 py-0.5 rounded uppercase leading-none">Rewards</span>
                        </div>
                        <!-- Sparkles decoration -->
                        <div class="absolute -top-3 -right-3 text-amber-400 font-bold text-lg select-none">&bull;&bull;</div>
                    </div>
                </div>

                <!-- Text titles -->
                <div class="space-y-3">
                    <h3 class="text-2xl font-black text-[#161233] leading-tight tracking-tight">
                        Don't leave without your<br>Aviaj Rewards!
                    </h3>
                    <p class="text-slate-600 text-xs font-semibold leading-relaxed">
                        Get $500 for your next vacation. Finish company account setup and reach the qualifying business travel spend within 30 days.*
                    </p>
                </div>

                <!-- Input form -->
                <form action="{{ route('demo-login') }}" method="GET" class="space-y-3">
                    <div class="relative">
                        <input type="email" required placeholder="Work Email (name@company.com)" class="w-full bg-white border border-slate-200 focus:border-[#59BABA] focus:ring-1 focus:ring-[#59BABA] pl-4 pr-4 py-3 rounded-xl text-xs text-[#0F172A] outline-none transition-all placeholder:text-slate-400">
                    </div>
                    
                    <p class="text-[9px] text-slate-400 leading-normal">
                        By continuing, you agree to receive marketing communications. See our <a href="#" class="underline">Privacy Policy</a>
                    </p>

                    <button type="submit" class="w-full inline-flex items-center justify-center py-3.5 font-extrabold text-white bg-[#59BABA] hover:bg-[#48A5A5] rounded-full shadow-lg shadow-[#59BABA]/20 hover:shadow-xl hover:-translate-y-0.5 transition-all duration-200 text-xs tracking-wider">
                        Get started
                    </button>
                </form>

                <!-- Disclaimer Footer -->
                <div class="space-y-1.5 text-[9px] text-slate-400 leading-normal border-t border-slate-200/50 pt-4">
                    <p>Aviaj Travel is free for companies up to 300 employees.</p>
                    <p class="text-center md:text-left"><a href="#" class="underline font-bold text-slate-500 hover:text-[#59BABA]">*See promotion terms and conditions</a></p>
                </div>
            </div>

            <!-- Right Half: Sunset clouds airplane visual and overlay -->
            <div class="md:col-span-6 relative overflow-hidden min-h-[360px] md:min-h-full rounded-2xl">
                <!-- Sunset clouds airplane image -->
                <img src="https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&q=80&w=800" 
                     alt="Airplane flying in sunset purple clouds" 
                     class="w-full h-full object-cover">
                <!-- Soft purple shade gradient -->
                <div class="absolute inset-0 bg-[#6F00FF]/15 mix-blend-multiply"></div>

                <!-- Floating Approval Card -->
                <div class="absolute inset-x-0 bottom-8 mx-auto max-w-[280px] bg-white border border-slate-100/50 p-4 rounded-2xl shadow-[0_15px_30px_rgba(0,0,0,0.1)] space-y-3 z-20">
                    <div class="flex justify-between items-center">
                        <div class="flex items-center space-x-2">
                            <img src="https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&q=80&w=150" class="w-6 h-6 rounded-full object-cover">
                            <span class="text-[10px] font-black text-slate-700">Barbara Colbert</span>
                        </div>
                        <span class="text-[9px] font-black text-emerald-600 bg-emerald-50 border border-emerald-100 rounded-full px-2 py-0.5 flex items-center space-x-0.5">
                            <span>&bull;</span>
                            <span>Approved</span>
                        </span>
                    </div>

                    <div class="flex justify-between items-end">
                        <div class="flex items-center space-x-2">
                            <!-- Delta logo simple representation -->
                            <div class="w-6 h-6 rounded bg-red-50 text-red-600 flex items-center justify-center font-bold text-xs shrink-0">&Delta;</div>
                            <div>
                                <span class="text-[10px] font-bold text-slate-800 block leading-none">Delta Air Lines</span>
                                <span class="text-[10px] font-extrabold text-slate-900">$392</span>
                            </div>
                        </div>
                        <span class="text-[10px] font-extrabold text-slate-500 tracking-tighter">SFO &rarr; JFK</span>
                    </div>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
