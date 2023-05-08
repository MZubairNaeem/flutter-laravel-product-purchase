<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Stripe\Stripe;

class StripeController extends Controller
{
    public function stripePost(Request $request)
    {
        try{
            $stripe = new \Stripe\StripeClient(
                'sk_test_51N1qH5JtifdFYGa2eVxxVit6fmTJPyVslHZl1upsWYMUaF0GsY96Hli5SL4TaL7ATplBPauDZunyNjvu7BuMYxnE005IO0YQvv'
              );
              $res = $stripe->tokens->create([
                'card' => [
                  'number' => $request->number,
                  'exp_month' => $request->exp_month,
                  'exp_year' => $request->exp_year,
                  'cvc' => $request->cvc,
                ],
              ]);
              Stripe::setApiKey(env('STRIPE_SECRET'));
              $responce = $stripe->charges->create([
                'amount' => $request->amount,
                'currency' => 'usd',
                'source' => 'tok_visa',
                'description' => $request->description,
              ]);
              return response()->json([$responce->status], 201);
        }
        catch(Exception $e){
            return response()->json([
                'message' => 'Error',
                'data' => $e
            ], 500);
        }
    }
    public function chargeCustomer(Request $request)
    {
      $stripeToken = $request->stripeToken;
      $amount = $request->amount;
      
      try {
        \Stripe\Charge::create([
          'amount' => $amount,
          'currency' => 'usd',
          'source' => $stripeToken,
        ]);
        
        return response()->json(['success' => true]);
      } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()]);
      }
    }
}
