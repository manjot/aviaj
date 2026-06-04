<?php

use App\Http\Controllers\DashboardController;
use Illuminate\Support\Facades\Route;

// Marketing Landing Page
Route::get('/', function () {
    return view('welcome');
});

// Dedicated Service Pages
Route::get('/ios-development', function () {
    return view('services.ios');
})->name('services.ios');

Route::get('/android-development', function () {
    return view('services.android');
})->name('services.android');

Route::get('/ecommerce-excellence', function () {
    return view('services.ecommerce');
})->name('services.ecommerce');

Route::get('/cross-platform', function () {
    return view('services.cross-platform');
})->name('services.cross-platform');

Route::get('/ai-powered-apps', function () {
    return view('services.ai-apps');
})->name('services.ai-apps');

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
