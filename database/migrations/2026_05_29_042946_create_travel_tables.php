<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // trips table: mock bookings
        Schema::create('trips', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('type'); // flight, hotel, car
            $table->string('title'); // e.g. "Flight to San Francisco (SFO)"
            $table->text('details'); // JSON or string of itinerary
            $table->date('start_date');
            $table->date('end_date')->nullable();
            $table->decimal('price', 10, 2);
            $table->string('status')->default('confirmed'); // pending, confirmed, cancelled
            $table->timestamps();
        });

        // expenses table: claims and receipt tracking
        Schema::create('expenses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('merchant');
            $table->decimal('amount', 10, 2);
            $table->string('category'); // Travel, Meals, Lodging, Software, etc.
            $table->date('date');
            $table->string('receipt_path')->nullable();
            $table->string('status')->default('pending'); // pending, approved, rejected
            $table->text('description')->nullable();
            $table->text('manager_notes')->nullable();
            $table->timestamps();
        });

        // corporate_cards table: virtual cards
        Schema::create('corporate_cards', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('card_number'); // masked/tokenized e.g. "**** **** **** 4242"
            $table->string('cardholder_name');
            $table->string('expiry_date'); // "12/29"
            $table->string('cvv'); // mock cvv
            $table->string('card_type')->default('Visa');
            $table->decimal('limit_amount', 10, 2)->default(5000.00);
            $table->decimal('spent_amount', 10, 2)->default(0.00);
            $table->string('status')->default('active'); // active, paused, terminated
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('corporate_cards');
        Schema::dropIfExists('expenses');
        Schema::dropIfExists('trips');
    }
};
