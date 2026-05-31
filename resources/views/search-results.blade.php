<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Flights | Aviaj Premium</title>
    <meta name="description" content="Efficient, policy-compliant travel booking for the modern enterprise. Powered by Aviaj AI.">
    
    <!-- Modern Premium Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Alpine.js Core -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="font-sans text-[#0F172A] bg-slate-50/50 antialiased overflow-x-hidden selection:bg-[#3A9F9F]/20"
      x-data="{
          selectedFlight: null,
          totalPrice: '$0.00',
          pointsEarned: '0 pts',
          policyCompliant: false,
          directOnly: false,
          refundable: false,
          selectedAirline: 'all',
          flights: [
              {
                  id: 1,
                  airline: 'United Airlines',
                  code: 'UA 901',
                  equipment: 'Boeing 787',
                  depTime: '07:20 PM',
                  depAirport: 'SFO',
                  arrTime: '01:50 PM',
                  arrAirport: 'LHR',
                  duration: '10h 30m',
                  stops: 'Direct',
                  price: 842,
                  points: 2500,
                  logoBg: 'bg-blue-900',
                  logoInit: 'UA'
              },
              {
                  id: 2,
                  airline: 'British Airways',
                  code: 'BA 284',
                  equipment: 'Airbus A350',
                  depTime: '05:15 PM',
                  depAirport: 'SFO',
                  arrTime: '11:30 AM',
                  arrAirport: 'LHR',
                  duration: '10h 15m',
                  stops: 'Direct',
                  price: 915,
                  points: 3120,
                  logoBg: 'bg-indigo-950',
                  logoInit: 'BA'
              },
              {
                  id: 3,
                  airline: 'Delta Air Lines',
                  code: 'DL 42',
                  equipment: 'Boeing 767',
                  depTime: '08:30 PM',
                  depAirport: 'SFO',
                  arrTime: '02:45 PM',
                  arrAirport: 'LHR',
                  duration: '10h 15m',
                  stops: 'Direct',
                  price: 890,
                  points: 2800,
                  logoBg: 'bg-red-800',
                  logoInit: 'DL'
              }
          ],
          selectFlight(f) {
              this.selectedFlight = f;
              this.totalPrice = '$' + f.price.toFixed(2);
              this.pointsEarned = f.points.toLocaleString() + ' pts';
          }
      }">

    <!-- Premium Glassmorphic Navigation Bar -->
    <header class="fixed top-0 inset-x-0 z-50 border-b border-slate-100 bg-white/85 backdrop-blur-xl">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <!-- Elegant New Custom Brand Logo -->
            <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold tracking-tight text-[#0F172A] transition-transform duration-300 hover:scale-102">
                <svg width="52" height="23" viewBox="0 0 52 23" fill="none" xmlns="http://www.w3.org/2000/svg" class="h-6 w-auto">
                    <path d="M12.6797 17.3906L11.2148 13.1719H4.92188L3.45703 17.3906H0L6.02344 0.878906H10.1016L16.1016 17.3906H12.6797ZM8.8125 5.82422C8.71875 5.55078 8.62695 5.27539 8.53711 4.99805C8.44727 4.7207 8.36914 4.4668 8.30273 4.23633C8.23633 4.00586 8.18164 3.81641 8.13867 3.66797C8.0957 3.51953 8.07031 3.4375 8.0625 3.42188C8.05469 3.44531 8.03125 3.53125 7.99219 3.67969C7.95312 3.82812 7.90039 4.01562 7.83398 4.24219C7.76758 4.46875 7.68945 4.7207 7.59961 4.99805C7.50977 5.27539 7.41797 5.55078 7.32422 5.82422L5.69531 10.5703H10.4414L8.8125 5.82422ZM21.8648 14.7305L25.0406 4.71094H28.4859L23.8102 17.3906H19.8727L15.3375 4.71094H18.818L21.8648 14.7305ZM29.6672 2.42578V0H32.9602V2.42578H29.6672ZM29.6672 17.3906V4.71094H32.9602V17.3906H29.6672ZM38.6648 17.625C38.0555 17.625 37.5105 17.541 37.0301 17.373C36.5496 17.2051 36.1414 16.959 35.8055 16.6348C35.4695 16.3105 35.2117 15.9102 35.032 15.4336C34.8523 14.957 34.7625 14.4141 34.7625 13.8047C34.7625 13.0547 34.8934 12.4238 35.1551 11.9121C35.4168 11.4004 35.7742 10.9863 36.2273 10.6699C36.6805 10.3535 37.2117 10.123 37.8211 9.97852C38.4305 9.83398 39.0789 9.75781 39.7664 9.75L42.4969 9.70312V9.05859C42.4969 8.59766 42.4559 8.21289 42.3738 7.9043C42.2918 7.5957 42.1727 7.34375 42.0164 7.14844C41.8602 6.95312 41.6668 6.81445 41.4363 6.73242C41.2059 6.65039 40.9422 6.60938 40.6453 6.60938C40.3719 6.60938 40.1277 6.63672 39.9129 6.69141C39.698 6.74609 39.5125 6.8418 39.3563 6.97852C39.2 7.11523 39.073 7.29883 38.9754 7.5293C38.8777 7.75977 38.8094 8.05078 38.7703 8.40234L35.3367 8.23828C35.4305 7.68359 35.6023 7.17773 35.8523 6.7207C36.1023 6.26367 36.448 5.86719 36.8895 5.53125C37.3309 5.19531 37.8738 4.93555 38.5184 4.75195C39.1629 4.56836 39.9188 4.47656 40.7859 4.47656C41.575 4.47656 42.2781 4.57422 42.8953 4.76953C43.5125 4.96484 44.0359 5.25586 44.4656 5.64258C44.8953 6.0293 45.2234 6.50391 45.45 7.06641C45.6766 7.62891 45.7898 8.28125 45.7898 9.02344V13.6406C45.7898 13.9375 45.8035 14.2031 45.8309 14.4375C45.8582 14.6719 45.909 14.8691 45.9832 15.0293C46.0574 15.1895 46.1629 15.3105 46.2996 15.3926C46.4363 15.4746 46.6141 15.5156 46.8328 15.5156C47.0828 15.5156 47.325 15.4922 47.5594 15.4453V17.2266C47.3641 17.2734 47.1883 17.3164 47.032 17.3555C46.8758 17.3945 46.7195 17.4258 46.5633 17.4492C46.407 17.4727 46.241 17.4922 46.0652 17.5078C45.8895 17.5234 45.6844 17.5312 45.45 17.5312C44.6219 17.5312 44.0105 17.3281 43.616 16.9219C43.2215 16.5156 42.9852 15.918 42.907 15.1289H42.8367C42.3992 15.918 41.8387 16.5312 41.1551 16.9688C40.4715 17.4062 39.6414 17.625 38.6648 17.625ZM42.4969 11.5195L40.8094 11.543C40.4578 11.5586 40.1238 11.5879 39.8074 11.6309C39.491 11.6738 39.2137 11.7637 38.9754 11.9004C38.7371 12.0371 38.5477 12.2344 38.407 12.4922C38.2664 12.75 38.1961 13.1016 38.1961 13.5469C38.1961 14.1484 38.3348 14.5957 38.6121 14.8887C38.8895 15.1816 39.2586 15.3281 39.7195 15.3281C40.1414 15.3281 40.5242 15.2383 40.868 15.0586C41.2117 14.8789 41.5027 14.6426 41.741 14.3496C41.9793 14.0566 42.1648 13.7188 42.2977 13.3359C42.4305 12.9531 42.4969 12.5625 42.4969 12.1641V11.5195ZM48.4945 2.42578V0H51.7875V2.42578H48.4945ZM48.4242 22.3711C47.9867 22.3711 47.6059 22.3613 47.2816 22.3418C46.9574 22.3223 46.6742 22.2969 46.432 22.2656V19.9453C46.5336 19.9609 46.6352 19.9727 46.7367 19.9805C46.8383 19.9883 46.9359 19.9922 47.0297 19.9922C47.3344 19.9922 47.5805 19.9609 47.768 19.8984C47.9555 19.8359 48.1039 19.7305 48.2133 19.582C48.3227 19.4336 48.3969 19.2383 48.4359 18.9961C48.475 18.7539 48.4945 18.4531 48.4945 18.0938V4.71094H51.7875V18.8906C51.7875 19.3984 51.725 19.8633 51.6 20.2852C51.475 20.707 51.2777 21.0742 51.0082 21.3867C50.7387 21.6992 50.391 21.9414 49.9652 22.1133C49.5395 22.2852 49.0258 22.3711 48.4242 22.3711Z" fill="#59BABA"/>
                </svg>
                <span class="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full bg-[#59BABA]/10 text-[#59BABA] tracking-widest">Premium Search</span>
            </a>

            <!-- Corporate Nav Elements -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-[#64748B]">
                <a href="/dashboard" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#59BABA] after:transition-all">Dashboard</a>
                <a href="#compliance" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#59BABA] after:transition-all">Policy Settings</a>
                <a href="#trips" class="hover:text-[#0F172A] transition-colors">My Bookings</a>
            </nav>

            <!-- Action Trigger -->
            <div class="flex items-center space-x-4">
                <a href="/dashboard" class="inline-flex items-center justify-center px-4 py-2 font-semibold text-white bg-[#59BABA] hover:bg-[#59BABA]/90 rounded-lg shadow-sm shadow-[#59BABA]/20 hover:shadow-md transition-all duration-200 text-sm">
                    Back to Portal
                </a>
            </div>
        </div>
    </header>

    <!-- Header spacing -->
    <div class="h-20"></div>

    <!-- Search Hero Header -->
    <section class="bg-gradient-to-b from-white to-slate-50/30 border-b border-slate-100 py-10 px-6">
        <div class="max-w-7xl mx-auto">
            <h1 class="text-3xl font-extrabold tracking-tight text-[#0F172A] font-sans">
                Search your next journey
            </h1>
            <p class="text-sm text-[#64748B] mt-1 max-w-2xl">
                Efficient, policy-compliant travel booking for the modern enterprise. Powered by Aviaj AI.
            </p>

            <!-- Floating Elegant Search Form Widget -->
            <div class="mt-8 bg-white border border-slate-200/80 p-5 rounded-2xl shadow-lg max-w-5xl flex flex-col md:flex-row items-center gap-4">
                <div class="flex-1 w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    <!-- From -->
                    <div class="space-y-1.5">
                        <label class="text-xs font-bold text-slate-400 uppercase tracking-wider block">From</label>
                        <div class="relative">
                            <span class="absolute left-3 top-3.5 text-slate-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"/></svg>
                            </span>
                            <input type="text" value="{{ $from }}" class="w-full bg-slate-50/50 border border-slate-200/80 focus:border-[#59BABA] focus:bg-white focus:ring-1 focus:ring-[#59BABA] pl-9 pr-3 py-2.5 rounded-lg text-sm text-[#0F172A] font-semibold outline-none transition-all">
                        </div>
                    </div>

                    <!-- To -->
                    <div class="space-y-1.5">
                        <label class="text-xs font-bold text-slate-400 uppercase tracking-wider block">To</label>
                        <div class="relative">
                            <span class="absolute left-3 top-3.5 text-slate-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"/></svg>
                            </span>
                            <input type="text" value="{{ $to }}" class="w-full bg-slate-50/50 border border-slate-200/80 focus:border-[#59BABA] focus:bg-white focus:ring-1 focus:ring-[#59BABA] pl-9 pr-3 py-2.5 rounded-lg text-sm text-[#0F172A] font-semibold outline-none transition-all">
                        </div>
                    </div>

                    <!-- Dates -->
                    <div class="space-y-1.5">
                        <label class="text-xs font-bold text-slate-400 uppercase tracking-wider block">Dates</label>
                        <div class="relative">
                            <span class="absolute left-3 top-3.5 text-slate-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
                            </span>
                            <input type="text" value="{{ $dates }}" class="w-full bg-slate-50/50 border border-slate-200/80 focus:border-[#59BABA] focus:bg-white focus:ring-1 focus:ring-[#59BABA] pl-9 pr-3 py-2.5 rounded-lg text-sm text-[#0F172A] font-semibold outline-none transition-all">
                        </div>
                    </div>

                    <!-- Travelers -->
                    <div class="space-y-1.5">
                        <label class="text-xs font-bold text-slate-400 uppercase tracking-wider block">Travelers</label>
                        <div class="relative">
                            <span class="absolute left-3 top-3.5 text-slate-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/></svg>
                            </span>
                            <input type="text" value="{{ $travelers }}" class="w-full bg-slate-50/50 border border-slate-200/80 focus:border-[#59BABA] focus:bg-white focus:ring-1 focus:ring-[#59BABA] pl-9 pr-3 py-2.5 rounded-lg text-sm text-[#0F172A] font-semibold outline-none transition-all">
                        </div>
                    </div>
                </div>

                <!-- CTA -->
                <button type="button" class="w-full md:w-auto self-end px-6 py-2.5 bg-[#59BABA] hover:bg-[#59BABA]/95 text-white font-bold rounded-xl shadow-md transition-all duration-150 shrink-0 text-sm flex items-center justify-center gap-2 mt-4 md:mt-0">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                    <span>Search</span>
                </button>
            </div>
        </div>
    </section>

    <!-- Main Content Area Grid -->
    <main class="max-w-7xl mx-auto px-6 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- LEFT ASIDE: Sidebar Filters & Live Current Selection -->
            <aside class="col-span-1 lg:col-span-4 space-y-6">
                
                <!-- 1. Live Current Selection Box (Updated via Alpine) -->
                <div class="bg-white border border-slate-200/90 rounded-2xl p-5 shadow-sm space-y-4">
                    <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                        <h3 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Current Selection</h3>
                        <span class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-amber-500/10 text-amber-600 uppercase tracking-wider animate-pulse" x-show="!selectedFlight">Pending Selection</span>
                        <span class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-emerald-500/10 text-emerald-600 uppercase tracking-wider" x-show="selectedFlight">Selected</span>
                    </div>

                    <!-- Inner Selection Display Container -->
                    <div class="bg-slate-50 border border-slate-100 rounded-xl p-4 flex items-center gap-3">
                        <div class="w-9 h-9 rounded-lg bg-[#59BABA]/10 text-[#59BABA] flex items-center justify-center shrink-0">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"/></svg>
                        </div>
                        <div>
                            <p class="text-xs font-bold text-slate-800" x-text="selectedFlight ? selectedFlight.airline : 'Choose a Flight'"></p>
                            <p class="text-[10px] text-slate-400 font-medium" x-text="selectedFlight ? selectedFlight.code + ' • Round Trip' : 'SFO &rarr; LHR • Round Trip'"></p>
                        </div>
                    </div>

                    <!-- Estimated Totals & Live Math -->
                    <div class="grid grid-cols-2 gap-4 border-t border-slate-100 pt-4">
                        <div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Est. Total</span>
                            <span class="text-xl font-extrabold text-[#0F172A] tracking-tight transition-all duration-300" x-text="totalPrice"></span>
                        </div>
                        <div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Points Earned</span>
                            <span class="text-sm font-bold text-emerald-600 transition-all duration-300 block mt-1" x-text="pointsEarned"></span>
                        </div>
                    </div>
                </div>

                <!-- 2. Interactive Search Policy Checkboxes -->
                <div class="bg-white border border-slate-200/90 rounded-2xl p-5 shadow-sm space-y-4">
                    <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider">FILTERS</h3>
                    
                    <div class="space-y-3.5">
                        <!-- Policy Compliant checkbox -->
                        <label class="flex items-center justify-between cursor-pointer group">
                            <div class="flex items-center space-x-3">
                                <input type="checkbox" x-model="policyCompliant" class="w-4 h-4 rounded text-[#59BABA] focus:ring-[#59BABA] border-slate-300">
                                <span class="text-sm font-semibold text-slate-700 group-hover:text-slate-900 transition-colors">Policy Compliant</span>
                            </div>
                            <span class="text-[9px] font-extrabold px-1.5 py-0.5 rounded bg-emerald-500/10 text-emerald-600 tracking-wider">SMART</span>
                        </label>

                        <!-- Direct Only checkbox -->
                        <label class="flex items-center space-x-3 cursor-pointer group">
                            <input type="checkbox" x-model="directOnly" class="w-4 h-4 rounded text-[#59BABA] focus:ring-[#59BABA] border-slate-300">
                            <span class="text-sm font-semibold text-slate-700 group-hover:text-slate-900 transition-colors">Direct Only</span>
                        </label>

                        <!-- Refundable checkbox -->
                        <label class="flex items-center space-x-3 cursor-pointer group">
                            <input type="checkbox" x-model="refundable" class="w-4 h-4 rounded text-[#59BABA] focus:ring-[#59BABA] border-slate-300">
                            <span class="text-sm font-semibold text-slate-700 group-hover:text-slate-900 transition-colors">Refundable</span>
                        </label>
                    </div>
                </div>

                <!-- 3. Airline Pricing stacks -->
                <div class="bg-white border border-slate-200/90 rounded-2xl p-5 shadow-sm space-y-4">
                    <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider">AIRLINES</h3>
                    
                    <div class="space-y-2.5">
                        <!-- All Airlines button option -->
                        <button type="button" @click="selectedAirline = 'all'"
                                class="w-full text-left px-3 py-2 rounded-xl text-xs font-bold flex justify-between items-center transition-all duration-150"
                                :class="selectedAirline === 'all' ? 'bg-[#59BABA]/10 text-[#59BABA]' : 'text-slate-600 hover:bg-slate-50'">
                            <span>All Airlines</span>
                            <span class="text-[10px] text-slate-400 font-semibold">$842+</span>
                        </button>

                        <!-- United stack -->
                        <button type="button" @click="selectedAirline = 'united'"
                                class="w-full text-left px-3 py-2 rounded-xl text-xs font-bold flex justify-between items-center transition-all duration-150"
                                :class="selectedAirline === 'united' ? 'bg-[#59BABA]/10 text-[#59BABA]' : 'text-slate-600 hover:bg-slate-50'">
                            <span>United Airlines</span>
                            <span class="text-[10px] text-slate-400 font-semibold">$842+</span>
                        </button>

                        <!-- British Airways stack -->
                        <button type="button" @click="selectedAirline = 'british'"
                                class="w-full text-left px-3 py-2 rounded-xl text-xs font-bold flex justify-between items-center transition-all duration-150"
                                :class="selectedAirline === 'british' ? 'bg-[#59BABA]/10 text-[#59BABA]' : 'text-slate-600 hover:bg-slate-50'">
                            <span>British Airways</span>
                            <span class="text-[10px] text-slate-400 font-semibold">$915+</span>
                        </button>

                        <!-- Delta stack -->
                        <button type="button" @click="selectedAirline = 'delta'"
                                class="w-full text-left px-3 py-2 rounded-xl text-xs font-bold flex justify-between items-center transition-all duration-150"
                                :class="selectedAirline === 'delta' ? 'bg-[#59BABA]/10 text-[#59BABA]' : 'text-slate-600 hover:bg-slate-50'">
                            <span>Delta Air Lines</span>
                            <span class="text-[10px] text-slate-400 font-semibold">$890+</span>
                        </button>
                    </div>
                </div>

            </aside>

            <!-- RIGHT SECTION: Recommended Flight List -->
            <section class="col-span-1 lg:col-span-8 space-y-6">
                
                <div class="flex items-center justify-between">
                    <h2 class="text-lg font-bold text-slate-900">Recommended Flights</h2>
                    <div class="flex items-center gap-2">
                        <span class="text-xs text-slate-500 font-medium">Sort:</span>
                        <button class="px-3.5 py-1.5 bg-white border border-slate-200 text-xs font-bold rounded-lg hover:border-slate-300 transition-colors">
                            Recommended
                        </button>
                    </div>
                </div>

                <!-- Flight List -->
                <div class="space-y-4">
                    <template x-for="f in flights" :key="f.id">
                        <!-- Flight Result Card -->
                        <div x-show="(selectedAirline === 'all' || (selectedAirline === 'united' && f.id === 1) || (selectedAirline === 'british' && f.id === 2) || (selectedAirline === 'delta' && f.id === 3))"
                             class="bg-white border p-5 rounded-2xl shadow-sm transition-all duration-200 flex flex-col md:flex-row gap-5 items-stretch relative overflow-hidden"
                             :class="selectedFlight && selectedFlight.id === f.id ? 'border-[#59BABA] ring-1 ring-[#59BABA]/50 shadow-md' : 'border-slate-200/80 hover:shadow-md'">
                            
                            <!-- Highlight Glow if Selected -->
                            <div x-show="selectedFlight && selectedFlight.id === f.id" class="absolute top-0 right-0 bg-[#59BABA] text-white text-[9px] font-extrabold px-3 py-1 rounded-bl-xl tracking-wider uppercase">
                                Selected
                            </div>

                            <!-- Left: Airline logo & Flight Info -->
                            <div class="flex-1 flex flex-col justify-between space-y-4 md:space-y-0">
                                <div class="flex items-start gap-4">
                                    <!-- Dynamic Logo Badges -->
                                    <div class="w-11 h-11 rounded-xl flex items-center justify-center text-white text-sm font-extrabold shrink-0" :class="f.logoBg">
                                        <span x-text="f.logoInit"></span>
                                    </div>
                                    <div>
                                        <h4 class="text-sm font-bold text-slate-800" x-text="f.airline"></h4>
                                        <p class="text-[10px] text-slate-400 font-medium" x-text="f.code + ' • ' + f.equipment"></p>
                                    </div>
                                </div>

                                <!-- Schedule flight details -->
                                <div class="grid grid-cols-3 gap-2 pt-2 text-center md:text-left">
                                    <div>
                                        <p class="text-base font-extrabold text-slate-900" x-text="f.depTime"></p>
                                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider" x-text="f.depAirport"></p>
                                    </div>
                                    <div class="flex flex-col items-center justify-center px-2">
                                        <span class="text-[10px] text-slate-400 font-semibold" x-text="f.duration"></span>
                                        <!-- Timeline line visual representation -->
                                        <div class="w-full relative h-1 flex items-center justify-center my-1 bg-slate-100 rounded-full">
                                            <div class="absolute w-2 h-2 rounded-full bg-[#59BABA] border border-white"></div>
                                        </div>
                                        <span class="text-[9px] text-[#59BABA] font-bold tracking-wider uppercase" x-text="f.stops"></span>
                                    </div>
                                    <div class="text-right md:text-left">
                                        <p class="text-base font-extrabold text-slate-900 flex items-center justify-end md:justify-start">
                                            <span x-text="f.arrTime"></span>
                                            <span class="text-[9px] font-semibold text-[#59BABA] ml-0.5" x-show="f.nextDay">+1d</span>
                                        </p>
                                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider" x-text="f.arrAirport"></p>
                                    </div>
                                </div>

                                <!-- Policy Badges stack -->
                                <div class="pt-3 flex flex-wrap gap-2">
                                    <span class="inline-flex items-center gap-1.5 text-[9px] font-extrabold px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-600 uppercase tracking-wider">
                                        <svg class="w-2.5 h-2.5" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/></svg>
                                        In Policy
                                    </span>
                                    <span class="inline-flex items-center gap-1.5 text-[9px] font-extrabold px-2 py-0.5 rounded-full bg-[#59BABA]/10 text-[#59BABA] uppercase tracking-wider">
                                        Corporate Rate
                                    </span>
                                </div>
                            </div>

                            <!-- Right Pricing & Booking select -->
                            <div class="w-full md:w-44 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-0 md:pl-5 flex flex-row md:flex-col justify-between md:justify-center items-center md:items-stretch space-y-0 md:space-y-3 shrink-0">
                                <div class="text-left md:text-center">
                                    <p class="text-2xl font-extrabold text-[#0F172A] tracking-tight" x-text="'$' + f.price"></p>
                                    <p class="text-[10px] font-bold text-emerald-600 block mt-0.5" x-text="'+' + f.points.toLocaleString() + ' pts'"></p>
                                </div>
                                <button type="button" @click="selectFlight(f)"
                                        class="px-5 py-2 text-xs font-bold rounded-lg shadow-sm border transition-all duration-150 w-auto md:w-full"
                                        :class="selectedFlight && selectedFlight.id === f.id ? 'bg-[#59BABA] border-[#59BABA] text-white hover:bg-[#59BABA]/90 shadow-[#59BABA]/20' : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50 hover:border-slate-300'">
                                    <span x-text="selectedFlight && selectedFlight.id === f.id ? 'Selected' : 'Select Flight'"></span>
                                </button>
                            </div>

                        </div>
                    </template>
                </div>

                <!-- BENTO INTERVENTION: Aviaj AI Assistant Card -->
                <div class="bg-gradient-to-tr from-slate-900 to-slate-950 text-white rounded-3xl p-6 shadow-xl relative overflow-hidden border border-slate-800">
                    <!-- Background aesthetic circles -->
                    <div class="absolute -top-12 -right-12 w-48 h-48 bg-[#59BABA]/15 rounded-full filter blur-2xl animate-pulse"></div>
                    <div class="absolute -bottom-8 -left-8 w-32 h-32 bg-indigo-500/10 rounded-full filter blur-xl"></div>
                    
                    <!-- Outer container -->
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-center relative z-10">
                        <div class="md:col-span-7 space-y-4">
                            <div class="flex items-center gap-2">
                                <span class="w-2.5 h-2.5 rounded-full bg-[#59BABA] animate-ping"></span>
                                <span class="text-[10px] uppercase font-extrabold tracking-widest text-[#59BABA]">Aviaj AI Assistant</span>
                            </div>
                            
                            <h3 class="text-xl font-bold tracking-tight leading-tight">
                                Need a hotel near Paddington Station?
                            </h3>
                            
                            <p class="text-xs text-slate-400 leading-relaxed max-w-sm">
                                I've found 3 properties that match your usual style and are within company budget for London.
                            </p>

                            <button class="px-4.5 py-2 bg-[#59BABA] hover:bg-[#59BABA]/90 text-white text-xs font-bold rounded-lg shadow-sm shadow-[#59BABA]/20 transition-all duration-150">
                                Show Recommendations
                            </button>
                        </div>

                        <!-- Right: Glassmorphic Hotel Preview Card -->
                        <div class="md:col-span-5">
                            <div class="bg-white/10 border border-white/10 p-4 rounded-2xl shadow-xl backdrop-blur-md space-y-3">
                                <!-- Hotel Photo container -->
                                <div class="h-28 rounded-lg bg-slate-800/80 overflow-hidden relative border border-white/5">
                                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=300" alt="Hotel" class="w-full h-full object-cover">
                                    <span class="absolute top-2 right-2 text-[8px] font-extrabold px-2 py-0.5 rounded bg-emerald-500 text-white uppercase tracking-wider">In Policy</span>
                                </div>
                                <!-- Hotel details -->
                                <div>
                                    <h4 class="text-xs font-bold text-white tracking-tight">Canopy by Hilton London</h4>
                                    <div class="flex items-center gap-0.5 mt-1 text-amber-400">
                                        <!-- 5 Stars SVG -->
                                        <svg class="w-2.5 h-2.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <svg class="w-2.5 h-2.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <svg class="w-2.5 h-2.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <svg class="w-2.5 h-2.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <svg class="w-2.5 h-2.5 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <span class="text-[9px] text-slate-300 font-semibold ml-1">5.0 (420)</span>
                                    </div>
                                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-white/5">
                                        <span class="text-[9px] font-bold text-slate-400 block uppercase">Est. Nightly</span>
                                        <span class="text-xs font-extrabold text-white tracking-tight">$215</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </section>
        </div>
    </main>

    <!-- Full Width Footer -->
    <footer class="bg-white border-t border-slate-200/80 py-12 px-6 mt-20">
        <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
            <div class="space-y-4">
                <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold text-[#0F172A]">
                    <svg width="52" height="23" viewBox="0 0 52 23" fill="none" xmlns="http://www.w3.org/2000/svg" class="h-6 w-auto">
                        <path d="M12.6797 17.3906L11.2148 13.1719H4.92188L3.45703 17.3906H0L6.02344 0.878906H10.1016L16.1016 17.3906H12.6797ZM8.8125 5.82422C8.71875 5.55078 8.62695 5.27539 8.53711 4.99805C8.44727 4.7207 8.36914 4.4668 8.30273 4.23633C8.23633 4.00586 8.18164 3.81641 8.13867 3.66797C8.0957 3.51953 8.07031 3.4375 8.0625 3.42188C8.05469 3.44531 8.03125 3.53125 7.99219 3.67969C7.95312 3.82812 7.90039 4.01562 7.83398 4.24219C7.76758 4.46875 7.68945 4.7207 7.59961 4.99805C7.50977 5.27539 7.41797 5.55078 7.32422 5.82422L5.69531 10.5703H10.4414L8.8125 5.82422ZM21.8648 14.7305L25.0406 4.71094H28.4859L23.8102 17.3906H19.8727L15.3375 4.71094H18.818L21.8648 14.7305ZM29.6672 2.42578V0H32.9602V2.42578H29.6672ZM29.6672 17.3906V4.71094H32.9602V17.3906H29.6672ZM38.6648 17.625C38.0555 17.625 37.5105 17.541 37.0301 17.373C36.5496 17.2051 36.1414 16.959 35.8055 16.6348C35.4695 16.3105 35.2117 15.9102 35.032 15.4336C34.8523 14.957 34.7625 14.4141 34.7625 13.8047C34.7625 13.0547 34.8934 12.4238 35.1551 11.9121C35.4168 11.4004 35.7742 10.9863 36.2273 10.6699C36.6805 10.3535 37.2117 10.123 37.8211 9.97852C38.4305 9.83398 39.0789 9.75781 39.7664 9.75L42.4969 9.70312V9.05859C42.4969 8.59766 42.4559 8.21289 42.3738 7.9043C42.2918 7.5957 42.1727 7.34375 42.0164 7.14844C41.8602 6.95312 41.6668 6.81445 41.4363 6.73242C41.2059 6.65039 40.9422 6.60938 40.6453 6.60938C40.3719 6.60938 40.1277 6.63672 39.9129 6.69141C39.698 6.74609 39.5125 6.8418 39.3563 6.97852C39.2 7.11523 39.073 7.29883 38.9754 7.5293C38.8777 7.75977 38.8094 8.05078 38.7703 8.40234L35.3367 8.23828C35.4305 7.68359 35.6023 7.17773 35.8523 6.7207C36.1023 6.26367 36.448 5.86719 36.8895 5.53125C37.3309 5.19531 37.8738 4.93555 38.5184 4.75195C39.1629 4.56836 39.9188 4.47656 40.7859 4.47656C41.575 4.47656 42.2781 4.57422 42.8953 4.76953C43.5125 4.96484 44.0359 5.25586 44.4656 5.64258C44.8953 6.0293 45.2234 6.50391 45.45 7.06641C45.6766 7.62891 45.7898 8.28125 45.7898 9.02344V13.6406C45.7898 13.9375 45.8035 14.2031 45.8309 14.4375C45.8582 14.6719 45.909 14.8691 45.9832 15.0293C46.0574 15.1895 46.1629 15.3105 46.2996 15.3926C46.4363 15.4746 46.6141 15.5156 46.8328 15.5156C47.0828 15.5156 47.325 15.4922 47.5594 15.4453V17.2266C47.3641 17.2734 47.1883 17.3164 47.032 17.3555C46.8758 17.3945 46.7195 17.4258 46.5633 17.4492C46.407 17.4727 46.241 17.4922 46.0652 17.5078C45.8895 17.5234 45.6844 17.5312 45.45 17.5312C44.6219 17.5312 44.0105 17.3281 43.616 16.9219C43.2215 16.5156 42.9852 15.918 42.907 15.1289H42.8367C42.3992 15.918 41.8387 16.5312 41.1551 16.9688C40.4715 17.4062 39.6414 17.625 38.6648 17.625ZM42.4969 11.5195L40.8094 11.543C40.4578 11.5586 40.1238 11.5879 39.8074 11.6309C39.491 11.6738 39.2137 11.7637 38.9754 11.9004C38.7371 12.0371 38.5477 12.2344 38.407 12.4922C38.2664 12.75 38.1961 13.1016 38.1961 13.5469C38.1961 14.1484 38.3348 14.5957 38.6121 14.8887C38.8895 15.1816 39.2586 15.3281 39.7195 15.3281C40.1414 15.3281 40.5242 15.2383 40.868 15.0586C41.2117 14.8789 41.5027 14.6426 41.741 14.3496C41.9793 14.0566 42.1648 13.7188 42.2977 13.3359C42.4305 12.9531 42.4969 12.5625 42.4969 12.1641V11.5195ZM48.4945 2.42578V0H51.7875V2.42578H48.4945ZM48.4242 22.3711C47.9867 22.3711 47.6059 22.3613 47.2816 22.3418C46.9574 22.3223 46.6742 22.2969 46.432 22.2656V19.9453C46.5336 19.9609 46.6352 19.9727 46.7367 19.9805C46.8383 19.9883 46.9359 19.9922 47.0297 19.9922C47.3344 19.9922 47.5805 19.9609 47.768 19.8984C47.9555 19.8359 48.1039 19.7305 48.2133 19.582C48.3227 19.4336 48.3969 19.2383 48.4359 18.9961C48.475 18.7539 48.4945 18.4531 48.4945 18.0938V4.71094H51.7875V18.8906C51.7875 19.3984 51.725 19.8633 51.6 20.2852C51.475 20.707 51.2777 21.0742 51.0082 21.3867C50.7387 21.6992 50.391 21.9414 49.9652 22.1133C49.5395 22.2852 49.0258 22.3711 48.4242 22.3711Z" fill="#59BABA"/>
                    </svg>
                </a>
                <p class="text-xs text-slate-500 font-medium max-w-xs leading-relaxed">
                    Precise corporate travel and expense management. Empowering global teams to move faster.
                </p>
            </div>
            <div>
                <h5 class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">Product</h5>
                <ul class="space-y-2 text-xs font-semibold text-slate-600">
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Travel Booking</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Spend Control</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Corporate Cards</a></li>
                </ul>
            </div>
            <div>
                <h5 class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">Solutions</h5>
                <ul class="space-y-2 text-xs font-semibold text-slate-600">
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Enterprise</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Startups</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Travel Managers</a></li>
                </ul>
            </div>
            <div>
                <h5 class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">Company</h5>
                <ul class="space-y-2 text-xs font-semibold text-slate-600">
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">About Us</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Support Center</a></li>
                    <li><a href="#" class="hover:text-[#59BABA] transition-colors">Privacy Policy</a></li>
                </ul>
            </div>
        </div>
    </footer>

</body>
</html>
