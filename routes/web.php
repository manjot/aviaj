<?php

use App\Http\Controllers\DashboardController;
use Illuminate\Support\Facades\Route;

// Marketing Landing Page
Route::get('/', function () {
    return view('welcome');
});

// Flight Search Results Page
Route::get('/search-flights', [DashboardController::class, 'searchFlights'])->name('search-flights');

// Expense Management Dashboard
Route::get('/expense-management', [DashboardController::class, 'expenseManagement'])->name('expense-management');

// Custom High-Fidelity Get Started Registration
Route::get('/get-started', function () {
    return view('get-started');
})->name('get-started');
Route::post('/get-started', [DashboardController::class, 'submitEmail'])->name('get-started.submit');

// Demo login shortcut
Route::get('/demo-login', [DashboardController::class, 'demoLogin'])->name('demo-login');

// Corporate Dashboard Portal (All routes grouped or direct)
Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
Route::post('/dashboard/book', [DashboardController::class, 'bookTravel'])->name('dashboard.book');
Route::post('/dashboard/expense', [DashboardController::class, 'addExpense'])->name('dashboard.expense');
Route::post('/dashboard/card', [DashboardController::class, 'createCard'])->name('dashboard.card');
Route::post('/dashboard/card/{id}/toggle', [DashboardController::class, 'toggleCardStatus'])->name('dashboard.card.toggle');

// Manager Role & Approvals Portal Routes
Route::post('/dashboard/toggle-role', [DashboardController::class, 'toggleRole'])->name('dashboard.toggle-role');
Route::post('/dashboard/approve/trip/{id}', [DashboardController::class, 'approveTrip'])->name('dashboard.approve.trip');
Route::post('/dashboard/reject/trip/{id}', [DashboardController::class, 'rejectTrip'])->name('dashboard.reject.trip');
Route::post('/dashboard/approve/expense/{id}', [DashboardController::class, 'approveExpense'])->name('dashboard.approve.expense');
Route::post('/dashboard/reject/expense/{id}', [DashboardController::class, 'rejectExpense'])->name('dashboard.reject.expense');
