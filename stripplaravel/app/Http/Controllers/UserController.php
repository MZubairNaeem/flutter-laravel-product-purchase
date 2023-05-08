<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Password;
use Validator;

class UserController extends Controller
{
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }
    public function createUser(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|unique:users|max:255',
                'password' => 'required|string|min:8',
            ]);
    
            // Create and save the user
            $user = new User();
            $user->name = $validatedData['name'];
            $user->email = $validatedData['email'];
            $user->password = bcrypt($validatedData['password']);
            $user->save();
    
            // Return a JSON response
            return response()->json([
                'message' => 'User created successfully'
            ], 201);
        } catch (QueryException $e) {
            return response()->json(['error' => 'Failed to create user'], 500);
        }
        // Validate user input
        
    }
    public function loginUser(Request $request)
    {
        // Validate user input
        $validatedData = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        // Attempt to authenticate the user
        if (!Auth::attempt($validatedData)) {
            return response()->json([
                'message' => 'Invalid credentials'
            ], 401);
        }

        // Generate a token
        $token = Auth::user()->createToken('auth_token')->plainTextToken;

        // Return a JSON response
        return response()->json([
            'message' => 'Login successful',
            'access_token' => $token
        ]);
    }
    public function logout()
    {
        Auth::logout();
        return response()->json(['message' => 'Successfully logged out']);
    }   
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 401);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $token = Password::createToken($user);

        // Send email with password reset link
        $user->sendPasswordResetNotification($token);

        return response()->json(['message' => 'Reset password link sent to your email'], 200);
    }
    public function getUserID()
    {
        $user = Auth::user();
        
        if ($user) {
            return response()->json(['id' => $user->id]);
        } else {
            return response()->json(['error' => 'Unauthenticated'], 401);
        }
    }
}
