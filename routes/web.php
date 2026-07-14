<?php

use App\Livewire\TestPage;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
})->name('home');

Route::get('/test-page', TestPage::class)->name('test-page');

Route::get('/prototype', function () {
    return response()->file(resource_path('prototypes/shifan-travel.html'));
})->name('prototype');
