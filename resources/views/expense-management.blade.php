<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Corporate Expenses & Reimbursements | Aviaj</title>
    <meta name="description" content="Precise corporate travel and expense management. Empowering global teams to move faster.">
    
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
          showUploadModal: false,
          showReportModal: false,
          toastMessage: '',
          toastType: 'success',
          policyCapResolved: false,
          savingsOptimized: false,
          newReportName: '',
          newReportDept: 'Sales',
          uploadFileName: '',
          uploadAmount: '',
          transactions: [
              {
                  id: 1,
                  merchant: 'Delta Airlines',
                  description: 'DL142 - Travel',
                  date: 'Oct 24, 2023',
                  status: 'Processing',
                  statusBg: 'bg-amber-500/10 text-amber-600',
                  amount: 542.00,
                  receiptIcon: true,
                  categoryIcon: 'flight'
              },
              {
                  id: 2,
                  merchant: 'Marriott International',
                  description: 'Lodging - Austin',
                  date: 'Oct 22, 2023',
                  status: 'Approved',
                  statusBg: 'bg-emerald-500/10 text-emerald-600',
                  amount: 829.12,
                  receiptIcon: true,
                  categoryIcon: 'hotel'
              },
              {
                  id: 3,
                  merchant: 'Uber Technologies',
                  description: 'Transport',
                  date: 'Oct 21, 2023',
                  status: 'Policy Flag',
                  statusBg: 'bg-rose-500/10 text-rose-600',
                  amount: 45.30,
                  receiptIcon: false,
                  categoryIcon: 'car'
              }
          ],
          activities: [
              {
                  id: 1,
                  title: 'Reimbursement approved',
                  desc: 'Your trip to Austin report #9421 was approved.',
                  time: '2h ago',
                  iconBg: 'bg-emerald-500/15 text-emerald-600',
                  type: 'success'
              },
              {
                  id: 2,
                  title: 'Report modified',
                  desc: 'Manager requested clarification on \'Dinner - client\'.',
                  time: '5h ago',
                  iconBg: 'bg-amber-500/15 text-amber-600',
                  type: 'warning'
              },
              {
                  id: 3,
                  title: 'New invite received',
                  desc: 'Invited to \'Team Q4 Offsite\' shared report.',
                  time: 'Yesterday',
                  iconBg: 'bg-[#59BABA]/15 text-[#59BABA]',
                  type: 'invite'
              }
          ],
          triggerToast(msg, type='success') {
              this.toastMessage = msg;
              this.toastType = type;
              setTimeout(() => { this.toastMessage = ''; }, 3500);
          },
          resolvePolicy() {
              this.policyCapResolved = true;
              this.transactions[2].status = 'Approved';
              this.transactions[2].statusBg = 'bg-emerald-500/10 text-emerald-600';
              this.activities.unshift({
                  id: Date.now(),
                  title: 'Policy violation resolved',
                  desc: 'Uber Black from JFK report resolved by capping at $50.',
                  time: 'Just now',
                  iconBg: 'bg-emerald-500/15 text-emerald-600',
                  type: 'success'
              });
              this.triggerToast('Uber policy cap resolved & capped at $50.00!');
          },
          optimizeSavings() {
              this.savingsOptimized = true;
              this.triggerToast('Hertz corporate rates optimized! Savings applied.');
          },
          handleUpload() {
              if(!this.uploadFileName || !this.uploadAmount) return;
              let amt = parseFloat(this.uploadAmount);
              this.transactions.unshift({
                  id: Date.now(),
                  merchant: this.uploadFileName,
                  description: 'AI Auto-categorized',
                  date: 'Today',
                  status: 'Approved',
                  statusBg: 'bg-emerald-500/10 text-emerald-600',
                  amount: amt,
                  receiptIcon: true,
                  categoryIcon: 'receipt'
              });
              this.activities.unshift({
                  id: Date.now(),
                  title: 'Receipt uploaded & reconciled',
                  desc: 'Simulated OCR matched: ' + this.uploadFileName + ' - $' + amt.toFixed(2),
                  time: 'Just now',
                  iconBg: 'bg-emerald-500/15 text-emerald-600',
                  type: 'success'
              });
              this.triggerToast('Receipt processed by Aviaj AI!');
              this.showUploadModal = false;
              this.uploadFileName = '';
              this.uploadAmount = '';
          },
          handleNewReport() {
              if(!this.newReportName) return;
              this.activities.unshift({
                  id: Date.now(),
                  title: 'New report created',
                  desc: 'Report \'' + this.newReportName + '\' successfully submitted for ' + this.newReportDept + '.',
                  time: 'Just now',
                  iconBg: 'bg-[#59BABA]/15 text-[#59BABA]',
                  type: 'invite'
              });
              this.triggerToast('Report \'' + this.newReportName + '\' submitted!');
              this.showReportModal = false;
              this.newReportName = '';
          }
      }">

    <!-- Toast Notification Notification -->
    <div class="fixed bottom-6 right-6 z-50 transition-all duration-300 transform"
         x-show="toastMessage"
         x-transition:enter="ease-out duration-300"
         x-transition:enter-start="opacity-0 translate-y-2 scale-95"
         x-transition:enter-end="opacity-100 translate-y-0 scale-100"
         x-transition:leave="ease-in duration-200"
         x-transition:leave-start="opacity-100 translate-y-0 scale-100"
         x-transition:leave-end="opacity-0 translate-y-2 scale-95"
         style="display: none;">
        <div class="flex items-center gap-3 px-5 py-4 bg-slate-900 border border-slate-800 text-white rounded-2xl shadow-xl">
            <span class="w-2.5 h-2.5 rounded-full bg-[#59BABA]"></span>
            <p class="text-xs font-bold font-sans" x-text="toastMessage"></p>
        </div>
    </div>

    <!-- Premium Glassmorphic Navigation Bar -->
    <header class="fixed top-0 inset-x-0 z-40 border-b border-slate-100 bg-white/85 backdrop-blur-xl">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <!-- Elegant Custom Brand Logo -->
            <a href="/" class="flex items-center space-x-2 text-2xl font-extrabold tracking-tight text-[#0F172A] transition-transform duration-300 hover:scale-102">
                <svg width="52" height="23" viewBox="0 0 52 23" fill="none" xmlns="http://www.w3.org/2000/svg" class="h-6 w-auto">
                    <path d="M12.6797 17.3906L11.2148 13.1719H4.92188L3.45703 17.3906H0L6.02344 0.878906H10.1016L16.1016 17.3906H12.6797ZM8.8125 5.82422C8.71875 5.55078 8.62695 5.27539 8.53711 4.99805C8.44727 4.7207 8.36914 4.4668 8.30273 4.23633C8.23633 4.00586 8.18164 3.81641 8.13867 3.66797C8.0957 3.51953 8.07031 3.4375 8.0625 3.42188C8.05469 3.44531 8.03125 3.53125 7.99219 3.67969C7.95312 3.82812 7.90039 4.01562 7.83398 4.24219C7.76758 4.46875 7.68945 4.7207 7.59961 4.99805C7.50977 5.27539 7.41797 5.55078 7.32422 5.82422L5.69531 10.5703H10.4414L8.8125 5.82422ZM21.8648 14.7305L25.0406 4.71094H28.4859L23.8102 17.3906H19.8727L15.3375 4.71094H18.818L21.8648 14.7305ZM29.6672 2.42578V0H32.9602V2.42578H29.6672ZM29.6672 17.3906V4.71094H32.9602V17.3906H29.6672ZM38.6648 17.625C38.0555 17.625 37.5105 17.541 37.0301 17.373C36.5496 17.2051 36.1414 16.959 35.8055 16.6348C35.4695 16.3105 35.2117 15.9102 35.032 15.4336C34.8523 14.957 34.7625 14.4141 34.7625 13.8047C34.7625 13.0547 34.8934 12.4238 35.1551 11.9121C35.4168 11.4004 35.7742 10.9863 36.2273 10.6699C36.6805 10.3535 37.2117 10.123 37.8211 9.97852C38.4305 9.83398 39.0789 9.75781 39.7664 9.75L42.4969 9.70312V9.05859C42.4969 8.59766 42.4559 8.21289 42.3738 7.9043C42.2918 7.5957 42.1727 7.34375 42.0164 7.14844C41.8602 6.95312 41.6668 6.81445 41.4363 6.73242C41.2059 6.65039 40.9422 6.60938 40.6453 6.60938C40.3719 6.60938 40.1277 6.63672 39.9129 6.69141C39.698 6.74609 39.5125 6.8418 39.3563 6.97852C39.2 7.11523 39.073 7.29883 38.9754 7.5293C38.8777 7.75977 38.8094 8.05078 38.7703 8.40234L35.3367 8.23828C35.4305 7.68359 35.6023 7.17773 35.8523 6.7207C36.1023 6.26367 36.448 5.86719 36.8895 5.53125C37.3309 5.19531 37.8738 4.93555 38.5184 4.75195C39.1629 4.56836 39.9188 4.47656 40.7859 4.47656C41.575 4.47656 42.2781 4.57422 42.8953 4.76953C43.5125 4.96484 44.0359 5.25586 44.4656 5.64258C44.8953 6.0293 45.2234 6.50391 45.45 7.06641C45.6766 7.62891 45.7898 8.28125 45.7898 9.02344V13.6406C45.7898 13.9375 45.8035 14.2031 45.8309 14.4375C45.8582 14.6719 45.909 14.8691 45.9832 15.0293C46.0574 15.1895 46.1629 15.3105 46.2996 15.3926C46.4363 15.4746 46.6141 15.5156 46.8328 15.5156C47.0828 15.5156 47.325 15.4922 47.5594 15.4453V17.2266C47.3641 17.2734 47.1883 17.3164 47.032 17.3555C46.8758 17.3945 46.7195 17.4258 46.5633 17.4492C46.407 17.4727 46.241 17.4922 46.0652 17.5078C45.8895 17.5234 45.6844 17.5312 45.45 17.5312C44.6219 17.5312 44.0105 17.3281 43.616 16.9219C43.2215 16.5156 42.9852 15.918 42.907 15.1289H42.8367C42.3992 15.918 41.8387 16.5312 41.1551 16.9688C40.4715 17.4062 39.6414 17.625 38.6648 17.625ZM42.4969 11.5195L40.8094 11.543C40.4578 11.5586 40.1238 11.5879 39.8074 11.6309C39.491 11.6738 39.2137 11.7637 38.9754 11.9004C38.7371 12.0371 38.5477 12.2344 38.407 12.4922C38.2664 12.75 38.1961 13.1016 38.1961 13.5469C38.1961 14.1484 38.3348 14.5957 38.6121 14.8887C38.8895 15.1816 39.2586 15.3281 39.7195 15.3281C40.1414 15.3281 40.5242 15.2383 40.868 15.0586C41.2117 14.8789 41.5027 14.6426 41.741 14.3496C41.9793 14.0566 42.1648 13.7188 42.2977 13.3359C42.4305 12.9531 42.4969 12.5625 42.4969 12.1641V11.5195ZM48.4945 2.42578V0H51.7875V2.42578H48.4945ZM48.4242 22.3711C47.9867 22.3711 47.6059 22.3613 47.2816 22.3418C46.9574 22.3223 46.6742 22.2969 46.432 22.2656V19.9453C46.5336 19.9609 46.6352 19.9727 46.7367 19.9805C46.8383 19.9883 46.9359 19.9922 47.0297 19.9922C47.3344 19.9922 47.5805 19.9609 47.768 19.8984C47.9555 19.8359 48.1039 19.7305 48.2133 19.582C48.3227 19.4336 48.3969 19.2383 48.4359 18.9961C48.475 18.7539 48.4945 18.4531 48.4945 18.0938V4.71094H51.7875V18.8906C51.7875 19.3984 51.725 19.8633 51.6 20.2852C51.475 20.707 51.2777 21.0742 51.0082 21.3867C50.7387 21.6992 50.391 21.9414 49.9652 22.1133C49.5395 22.2852 49.0258 22.3711 48.4242 22.3711Z" fill="#59BABA"/>
                </svg>
                <span class="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full bg-[#59BABA]/10 text-[#59BABA] tracking-widest">Expense Suite</span>
            </a>

            <!-- Corporate Nav Elements -->
            <nav class="hidden md:flex items-center space-x-8 font-medium text-[#64748B]">
                <a href="/search-flights" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#59BABA] after:transition-all">Travel</a>
                <a href="/dashboard" class="hover:text-[#0F172A] transition-colors relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 hover:after:w-full after:bg-[#59BABA] after:transition-all">Dashboard</a>
                <a href="#compliance" class="hover:text-[#0F172A] transition-colors">Compliance Rules</a>
            </nav>

            <!-- Action Button -->
            <div class="flex items-center space-x-4">
                <a href="/dashboard" class="inline-flex items-center justify-center px-4 py-2 font-semibold text-white bg-[#59BABA] hover:bg-[#59BABA]/90 rounded-lg shadow-sm shadow-[#59BABA]/20 hover:shadow-md transition-all duration-200 text-sm">
                    Back to Portal
                </a>
            </div>
        </div>
    </header>

    <!-- Header spacing -->
    <div class="h-20"></div>

    <!-- Main Container -->
    <main class="max-w-7xl mx-auto px-6 py-10">
        
        <!-- Header & Action Row -->
        <section class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-10">
            <div>
                <h1 class="text-3xl font-extrabold tracking-tight text-[#0F172A]">Expense Dashboard</h1>
                <p class="text-sm text-[#64748B] mt-1 font-medium">Welcome back, Alex. You have 3 pending approvals.</p>
            </div>
            
            <div class="flex items-center gap-3 w-full md:w-auto">
                <!-- Upload Receipts CTA -->
                <button type="button" @click="showUploadModal = true" id="btn-upload-receipts" class="flex-1 md:flex-initial px-5 py-2.5 bg-white border border-slate-200 hover:bg-slate-50 hover:border-slate-300 text-slate-800 text-xs font-bold rounded-xl shadow-sm transition-all duration-150 flex items-center justify-center gap-2">
                    <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"/></svg>
                    <span>Upload Receipts</span>
                </button>

                <!-- New Report CTA -->
                <button type="button" @click="showReportModal = true" id="btn-new-report" class="flex-1 md:flex-initial px-5 py-2.5 bg-[#59BABA] hover:bg-[#59BABA]/95 text-white text-xs font-bold rounded-xl shadow-md transition-all duration-150 flex items-center justify-center gap-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15"/></svg>
                    <span>New Report</span>
                </button>
            </div>
        </section>

        <!-- Dashboard Grid System -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- LEFT COLUMN: Transactions & Reimbursement summaries -->
            <div class="col-span-1 lg:col-span-8 space-y-8">
                
                <!-- Progress Summary Cards -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                    
                    <!-- Card 1: Total Spending -->
                    <div class="bg-white border border-slate-200/80 p-5 rounded-2xl shadow-sm space-y-4">
                        <div class="flex items-center justify-between">
                            <div class="w-9 h-9 rounded-xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75m0 .75v.75m0-.75h-.75m.75 0h3.75m-3.75 0h-.75m.75 0v3.75m0-3.75h3.75m-10.5 9h10.5M3.75 1.5h15c1.24 0 2.25 1.01 2.25 2.25v13.5c0 1.24-1.01 2.25-2.25 2.25h-15C2.51 19.5 1.5 18.49 1.5 17.25V3.75C1.5 2.51 2.51 1.5 3.75 1.5z"/></svg>
                            </div>
                            <span class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-emerald-500/15 text-emerald-600 uppercase tracking-wider">+12% vs last mo</span>
                        </div>
                        <div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Total Spending</span>
                            <span class="text-2xl font-extrabold text-[#0F172A] tracking-tight block mt-1">$4,280.50</span>
                        </div>
                    </div>

                    <!-- Card 2: In Reimbursement -->
                    <div class="bg-white border border-slate-200/80 p-5 rounded-2xl shadow-sm space-y-4">
                        <div class="flex items-center justify-between">
                            <div class="w-9 h-9 rounded-xl bg-amber-500/10 text-amber-600 flex items-center justify-center shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                            <span class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-amber-500/15 text-amber-600 uppercase tracking-wider">Pending 4d</span>
                        </div>
                        <div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">In Reimbursement</span>
                            <span class="text-2xl font-extrabold text-[#0F172A] tracking-tight block mt-1">$1,120.00</span>
                        </div>
                    </div>

                    <!-- Card 3: Approved This Week -->
                    <div class="bg-white border border-slate-200/80 p-5 rounded-2xl shadow-sm space-y-4">
                        <div class="flex items-center justify-between">
                            <div class="w-9 h-9 rounded-xl bg-[#59BABA]/10 text-[#59BABA] flex items-center justify-center shrink-0">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12c0 1.268-.63 2.39-1.593 3.068a3.745 3.745 0 01-1.043 3.296 3.745 3.745 0 01-3.296 1.043A3.745 3.745 0 0112 21c-1.268 0-2.39-.63-3.068-1.593a3.746 3.746 0 01-3.296-1.043 3.745 3.745 0 01-1.043-3.296A3.745 3.745 0 013 12c0-1.268.63-2.39 1.593-3.068a3.745 3.745 0 011.043-3.296 3.746 3.746 0 013.296-1.043A3.746 3.746 0 0112 3c1.268 0 2.39.63 3.068 1.593a3.746 3.746 0 013.296 1.043 3.746 3.746 0 011.043 3.296A3.745 3.745 0 0121 12z"/></svg>
                            </div>
                            <span class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-emerald-500/15 text-emerald-600 uppercase tracking-wider">Success</span>
                        </div>
                        <div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Approved This Week</span>
                            <span class="text-2xl font-extrabold text-[#0F172A] tracking-tight block mt-1">$850.25</span>
                        </div>
                    </div>

                </div>

                <!-- Recent Transactions Table -->
                <div class="bg-white border border-slate-200/80 rounded-2xl shadow-sm overflow-hidden">
                    <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                        <h2 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Recent Transactions</h2>
                        <button class="text-xs font-bold text-[#59BABA] hover:text-[#59BABA]/80 transition-colors">View All</button>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50 border-b border-slate-150 text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                                    <th class="py-3.5 px-5">Merchant</th>
                                    <th class="py-3.5 px-4">Date</th>
                                    <th class="py-3.5 px-4">Status</th>
                                    <th class="py-3.5 px-4">Receipt</th>
                                    <th class="py-3.5 px-5 text-right">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="t in transactions" :key="t.id">
                                    <tr class="border-b border-slate-100 hover:bg-slate-50/50 transition-colors">
                                        <!-- Merchant -->
                                        <td class="py-4.5 px-5 flex items-center gap-3">
                                            <div class="w-9 h-9 rounded-lg bg-[#59BABA]/10 text-[#59BABA] flex items-center justify-center shrink-0">
                                                <template x-if="t.categoryIcon === 'flight'">
                                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"/></svg>
                                                </template>
                                                <template x-if="t.categoryIcon === 'hotel'">
                                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.24 9.81L12 3l9.76 6.81a.5.5 0 01.19.4v10.29a.5.5 0 01-.5.5h-19a.5.5 0 01-.5-.5V10.21a.5.5 0 01.19-.4zM12 12.5v5m-3-2.5h6"/></svg>
                                                </template>
                                                <template x-if="t.categoryIcon === 'car'">
                                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.129-1.125V11.25c0-1.897-1.424-3.497-3.3-3.691a54.18 54.18 0 00-11.4 0c-1.876.194-3.3 1.794-3.3 3.691V14.25m12 4.5h-.75m.75 0h-.75M3 14.25h18"/></svg>
                                                </template>
                                                <template x-if="t.categoryIcon === 'receipt'">
                                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"/></svg>
                                                </template>
                                            </div>
                                            <div>
                                                <span class="text-xs font-bold text-slate-800 block" x-text="t.merchant"></span>
                                                <span class="text-[10px] text-slate-400 font-medium block" x-text="t.description"></span>
                                            </div>
                                        </td>
                                        <!-- Date -->
                                        <td class="py-4.5 px-4 text-xs font-bold text-slate-500" x-text="t.date"></td>
                                        <!-- Status -->
                                        <td class="py-4.5 px-4">
                                            <span class="inline-flex items-center text-[9px] font-extrabold px-2 py-0.5 rounded-full uppercase tracking-wider"
                                                  :class="t.statusBg"
                                                  x-text="t.status"></span>
                                        </td>
                                        <!-- Receipt Icon -->
                                        <td class="py-4.5 px-4 text-slate-400">
                                            <template x-if="t.receiptIcon">
                                                <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"/></svg>
                                            </template>
                                            <template x-if="!t.receiptIcon">
                                                <span class="text-[10px] text-rose-500 font-bold hover:underline cursor-pointer" @click="showUploadModal = true; uploadFileName = t.merchant; uploadAmount = t.amount">Fix missing</span>
                                            </template>
                                        </td>
                                        <!-- Amount -->
                                        <td class="py-4.5 px-5 text-right text-xs font-bold text-slate-800" x-text="'$' + t.amount.toFixed(2)"></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <!-- RIGHT COLUMN: AI Insights & Activity Feed -->
            <div class="col-span-1 lg:col-span-4 space-y-8">
                
                <!-- AI Insights Panel -->
                <div class="bg-gradient-to-tr from-slate-900 to-slate-950 text-white rounded-3xl p-6 shadow-xl relative overflow-hidden border border-slate-800">
                    <div class="absolute -top-12 -right-12 w-48 h-48 bg-[#59BABA]/15 rounded-full filter blur-2xl"></div>
                    
                    <div class="relative z-10 space-y-5">
                        <div class="flex items-center gap-2 border-b border-white/5 pb-3">
                            <span class="w-2.5 h-2.5 rounded-full bg-[#59BABA] animate-pulse"></span>
                            <h3 class="text-xs uppercase font-extrabold tracking-widest text-[#59BABA]">AI Insights</h3>
                        </div>

                        <!-- Insight List -->
                        <div class="space-y-4">
                            <!-- Insight 1: Savings -->
                            <div class="bg-white/5 border border-white/5 p-4 rounded-xl space-y-3" x-show="!savingsOptimized">
                                <div class="flex items-center gap-2 text-[#59BABA]">
                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18m9-9H3"/></svg>
                                    <span class="text-xs font-extrabold tracking-tight">Potential Savings</span>
                                </div>
                                <p class="text-[11px] text-slate-300 leading-relaxed">
                                    Switching to the corporate rate for Hertz could save $140 on your next trip.
                                </p>
                                <button type="button" @click="optimizeSavings()" class="w-full py-1.5 bg-[#59BABA] hover:bg-[#59BABA]/95 text-white text-[10px] font-bold rounded-lg transition-all duration-150 text-center">
                                    Optimize Now
                                </button>
                            </div>

                            <!-- Insight 2: Policy Flag -->
                            <div class="bg-rose-500/10 border border-rose-500/20 p-4 rounded-xl space-y-3" x-show="!policyCapResolved">
                                <div class="flex items-center gap-2 text-rose-400">
                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                                    <span class="text-xs font-extrabold tracking-tight">Policy Violation</span>
                                </div>
                                <p class="text-[11px] text-rose-200/90 leading-relaxed">
                                    Uber Black from JFK exceeded the $50 transport cap by $12.50.
                                </p>
                                <button type="button" @click="resolvePolicy()" class="w-full py-1.5 bg-rose-500 hover:bg-rose-600 text-white text-[10px] font-bold rounded-lg transition-all duration-150 text-center">
                                    Resolve
                                </button>
                            </div>

                            <!-- Insight 3: Expiring Warning -->
                            <div class="bg-white/5 border border-white/5 p-4 rounded-xl space-y-2">
                                <div class="flex items-center gap-2 text-slate-300">
                                    <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                    <span class="text-xs font-extrabold tracking-tight">Expiring Reimbursement</span>
                                </div>
                                <p class="text-[11px] text-slate-400 leading-relaxed">
                                    3 receipts from September will expire in 48 hours. Auto-submit recommended.
                                </p>
                            </div>
                        </div>

                        <!-- Auto-Reconciliation visual element -->
                        <div class="bg-white/5 border border-white/5 rounded-xl p-4 flex items-center justify-between pt-3 mt-4">
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Auto-Reconcile</span>
                            <span class="text-[10px] font-extrabold text-[#59BABA] px-2 py-0.5 rounded bg-[#59BABA]/10 tracking-widest uppercase">98% Enabled</span>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity Feed -->
                <div class="bg-white border border-slate-200/80 rounded-2xl p-5 shadow-sm space-y-4">
                    <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider border-b border-slate-50 pb-2">ACTIVITY FEED</h3>
                    
                    <div class="space-y-6 relative pl-3.5 pt-2">
                        <!-- Left timeline line visual -->
                        <div class="absolute left-1.5 top-3 bottom-3 w-0.5 bg-slate-100"></div>

                        <template x-for="act in activities" :key="act.id">
                            <div class="relative flex gap-3 items-start transition-all duration-300">
                                <!-- Bullet point -->
                                <div class="absolute -left-3.5 mt-1.5 w-2 h-2 rounded-full border-2 border-white bg-slate-300"
                                     :class="act.type === 'success' ? 'bg-emerald-500' : (act.type === 'warning' ? 'bg-amber-500' : 'bg-[#59BABA]')"></div>
                                
                                <div>
                                    <h4 class="text-xs font-bold text-slate-800" x-text="act.title"></h4>
                                    <p class="text-[11px] text-slate-500 leading-relaxed mt-0.5" x-text="act.desc"></p>
                                    <span class="text-[9px] text-slate-400 font-bold block mt-1" x-text="act.time"></span>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>

            </div>

        </div>

    </main>

    <!-- Upload Receipt Modal Simulation -->
    <div class="fixed inset-0 z-50 overflow-y-auto" x-show="showUploadModal" style="display: none;">
        <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
            <!-- Overlay background -->
            <div class="fixed inset-0 transition-opacity bg-slate-900/50 backdrop-blur-sm" @click="showUploadModal = false"></div>
            
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen">&#8203;</span>

            <!-- Modal Content box -->
            <div class="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-3xl shadow-xl sm:my-8 sm:align-middle sm:max-w-md sm:w-full border border-slate-150">
                <div class="p-6 space-y-4">
                    <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                        <h3 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Simulate OCR Receipt Upload</h3>
                        <button type="button" @click="showUploadModal = false" class="text-slate-400 hover:text-slate-600">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                        </button>
                    </div>

                    <div class="space-y-3.5">
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Merchant Name</label>
                            <input type="text" x-model="uploadFileName" placeholder="e.g. Starlink Travel, Uber" class="w-full bg-slate-50 border border-slate-200 focus:border-[#59BABA] focus:bg-white pl-3 pr-3 py-2 rounded-lg text-xs outline-none transition-all">
                        </div>

                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Total Amount ($)</label>
                            <input type="number" x-model="uploadAmount" placeholder="e.g. 54.20" class="w-full bg-slate-50 border border-slate-200 focus:border-[#59BABA] focus:bg-white pl-3 pr-3 py-2 rounded-lg text-xs outline-none transition-all">
                        </div>

                        <!-- Dropzone mock visual -->
                        <div class="border-2 border-dashed border-slate-200 p-6 rounded-xl text-center space-y-2 hover:border-[#59BABA]/80 transition-colors cursor-pointer bg-slate-50/50">
                            <svg class="w-8 h-8 text-slate-400 mx-auto" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.233-2.33 3 3 0 013.758 3.848A3.752 3.752 0 0118 19.5H6.75z"/></svg>
                            <p class="text-xs font-bold text-slate-600">Simulate file attachment</p>
                            <p class="text-[10px] text-slate-400">PDF, PNG, JPG accepted (Max 5MB)</p>
                        </div>
                    </div>
                </div>

                <div class="px-6 py-4 bg-slate-50 border-t border-slate-100 flex items-center justify-end gap-3">
                    <button type="button" @click="showUploadModal = false" class="px-4 py-2 border border-slate-200 text-[11px] font-bold text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">Cancel</button>
                    <button type="button" @click="handleUpload()" :disabled="!uploadFileName || !uploadAmount" class="px-4 py-2 bg-[#59BABA] hover:bg-[#59BABA]/95 disabled:opacity-50 text-white text-[11px] font-bold rounded-lg transition-all shadow-md shadow-[#59BABA]/10">Process Receipt</button>
                </div>
            </div>
        </div>
    </div>

    <!-- New Report Modal Simulation -->
    <div class="fixed inset-0 z-50 overflow-y-auto" x-show="showReportModal" style="display: none;">
        <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
            <!-- Overlay background -->
            <div class="fixed inset-0 transition-opacity bg-slate-900/50 backdrop-blur-sm" @click="showReportModal = false"></div>
            
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen">&#8203;</span>

            <!-- Modal Content box -->
            <div class="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-3xl shadow-xl sm:my-8 sm:align-middle sm:max-w-md sm:w-full border border-slate-150">
                <div class="p-6 space-y-4">
                    <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                        <h3 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Create New Expense Report</h3>
                        <button type="button" @click="showReportModal = false" class="text-slate-400 hover:text-slate-600">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                        </button>
                    </div>

                    <div class="space-y-3.5">
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Report Title</label>
                            <input type="text" x-model="newReportName" placeholder="e.g. Q4 Executive Summit, Client Dinner" class="w-full bg-slate-50 border border-slate-200 focus:border-[#59BABA] focus:bg-white pl-3 pr-3 py-2 rounded-lg text-xs outline-none transition-all">
                        </div>

                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Cost Center Department</label>
                            <select x-model="newReportDept" class="w-full bg-slate-50 border border-slate-200 focus:border-[#59BABA] focus:bg-white pl-3 pr-3 py-2 rounded-lg text-xs outline-none transition-all">
                                <option value="Sales">Sales & Marketing</option>
                                <option value="Engineering">Engineering / Operations</option>
                                <option value="Executive">Executive Leadership</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="px-6 py-4 bg-slate-50 border-t border-slate-100 flex items-center justify-end gap-3">
                    <button type="button" @click="showReportModal = false" class="px-4 py-2 border border-slate-200 text-[11px] font-bold text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">Cancel</button>
                    <button type="button" @click="handleNewReport()" :disabled="!newReportName" class="px-4 py-2 bg-[#59BABA] hover:bg-[#59BABA]/95 disabled:opacity-50 text-white text-[11px] font-bold rounded-lg transition-all shadow-md shadow-[#59BABA]/10">Submit Report</button>
                </div>
            </div>
        </div>
    </div>

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
