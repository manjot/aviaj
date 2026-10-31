<?php
/**
 * Aviaj Stripe Payment Gateway Endpoint
 * Stripe Account: acct_1TNTVyJD1U0jWVOT
 * Dashboard: https://dashboard.stripe.com/acct_1TNTVyJD1U0jWVOT/dashboard
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$stripeAccountId = 'acct_1TNTVyJD1U0jWVOT';
$stripeSecretKey = getenv('STRIPE_SECRET_KEY') ?: '';

$input = json_decode(file_get_contents('php://input'), true) ?: $_POST;
$planName = $input['plan_name'] ?? 'Aviaj Gold Monthly';
$amountCents = intval(($input['amount_usd'] ?? 14.99) * 100);
$currency = strtolower($input['currency'] ?? 'usd');
$successUrl = $input['success_url'] ?? 'https://aviaj.com/?stripe_status=success';
$cancelUrl = $input['cancel_url'] ?? 'https://aviaj.com/?stripe_status=cancel';

if (!empty($stripeSecretKey)) {
    $ch = curl_init('https://api.stripe.com/v1/checkout/sessions');
    $postFields = http_build_query([
        'mode' => 'payment',
        'success_url' => $successUrl,
        'cancel_url' => $cancelUrl,
        'line_items[0][price_data][currency]' => $currency,
        'line_items[0][price_data][product_data][name]' => $planName,
        'line_items[0][price_data][unit_amount]' => $amountCents,
        'line_items[0][quantity]' => 1,
    ]);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $postFields,
        CURLOPT_USERPWD => $stripeSecretKey . ':',
        CURLOPT_HTTPHEADER => [
            'Stripe-Account: ' . $stripeAccountId,
        ],
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    http_response_code($httpCode ?: 200);
    echo $response;
    exit;
}

echo json_encode([
    'status' => 'ready',
    'stripe_account' => $stripeAccountId,
    'dashboard_url' => 'https://dashboard.stripe.com/acct_1TNTVyJD1U0jWVOT/dashboard',
    'plan_name' => $planName,
    'amount_cents' => $amountCents,
    'currency' => $currency,
]);

