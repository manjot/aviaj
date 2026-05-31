<?php

use App\Http\Controllers\DashboardController;
use Illuminate\Support\Facades\Route;

// Marketing Landing Page
Route::get('/', function () {
    return view('welcome');
});

// Demo login shortcut
Route::get('/demo-login', [DashboardController::class, 'demoLogin'])->name('demo-login');

// Corporate Dashboard Portal (All routes grouped or direct)
Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
Route::post('/dashboard/book', [DashboardController::class, 'bookTravel'])->name('dashboard.book');
Route::post('/dashboard/expense', [DashboardController::class, 'addExpense'])->name('dashboard.expense');
Route::post('/dashboard/card', [DashboardController::class, 'createCard'])->name('dashboard.card');
Route::post('/dashboard/card/{id}/toggle', [DashboardController::class, 'toggleCardStatus'])->name('dashboard.card.toggle');

Route::post('/contact', [DashboardController::class, 'submitContact'])->name('contact.submit');

// Thank You Page
Route::get('/thank-you', function () {
    return view('thankyou');
})->name('thankyou');

// Security scan route
Route::get('/admin-secure-scan', [DashboardController::class, 'runSecurityScan'])->name('admin.scan');
