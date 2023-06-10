<?php

namespace App\Http\Controllers;

use App\Mail\MailableName;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;


class EmailController extends Controller
{
    public function sendEmailWithPdf(Request $request)
    {
        // $data = [
        //     'name' => 'John Doe',
        //     'email' => 'johndoe@example.com'
        // ];
        $data = $request->validate([
            'name' => 'required|string',
            'email' => 'required|string',
            'totalAmount' => 'required|string',
        ]);
        $pdf = Pdf::loadView('invoice', $data);

        // Mail::send([], [], function ($message) use ($pdf, $data) {
        //     $message->to($data['email'])
        //         ->subject('Invoice')
        //         ->attachData($pdf->output(), 'invoice.pdf');
        // });

        Mail::send('invoice', $data,
        function($message) use($data, $pdf){
        $message->to($data['email'], $data['name'])
        ->subject('Post | '. $data['name'])
        ->attachData($pdf->output(), 'Post | '.$data['name'].'.pdf');
        // ->from('donotreply@kudon.com','Kudon Engineering');
        });
        return response()->json(['message' => 'Email sent with PDF attachment']);
    }
}
