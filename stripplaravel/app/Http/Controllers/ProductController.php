<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $products = Product::all();
    
        return response()->json([
            'message' => 'Successfully retrieved products.',
            'data' => $products
        ], 200);
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|string|min:0',
        ]);
    
        $product = new Product($data);
    
        $product->save();
    
        return response()->json([
            'message' => 'Product created successfully.',
            'data' => $product
        ], 201);
    }
    

    /**
     * Display the specified resource.
     */
    
}
