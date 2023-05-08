<?php


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\StripeController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

    Route::post('/signup', [UserController::class, 'createUser']);
    Route::post('/login', [UserController::class, 'loginUser']);
    // Route::middleware('auth:api')->post('/login', [UserController::class,'loginUser']);
    Route::post('/logout', [UserController::class,'logout']);
    Route::get('/users', [UserController::class, 'index']);
    Route::post('/reset-pass', [UserController::class, 'forgotPassword']);
    Route::get('/user/id', [UserController::class,'getUserID'])->middleware('auth:api');

    Route::post('/add/products', [ProductController::class,'store']);
    Route::get('/get/products', [ProductController::class,'index']);
    
    Route::post('/stripe', [StripeController::class, 'stripePost']);
    Route::post('/charge', [StripeController::class, 'chargeCustomer']);

