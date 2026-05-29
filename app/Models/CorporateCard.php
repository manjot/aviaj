<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CorporateCard extends Model
{
    protected $fillable = [
        'user_id',
        'card_number',
        'cardholder_name',
        'expiry_date',
        'cvv',
        'card_type',
        'limit_amount',
        'spent_amount',
        'status',
    ];

    protected $casts = [
        'limit_amount' => 'decimal:2',
        'spent_amount' => 'decimal:2',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
