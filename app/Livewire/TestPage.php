<?php

namespace App\Livewire;

use Illuminate\Contracts\View\View;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Title;
use Livewire\Component;

#[Layout('components.layouts.app')]
#[Title('W0 TestPage · 对味')]
class TestPage extends Component
{
    public string $name = '';

    public ?string $result = null;

    public function submit(): void
    {
        $validated = $this->validate(
            ['name' => ['required', 'string', 'min:2', 'max:30']],
            [
                'name.required' => '请输入你的名字。',
                'name.min' => '名字至少需要 2 个字符。',
                'name.max' => '名字不能超过 30 个字符。',
            ],
        );

        $this->result = "你好，{$validated['name']}！Livewire 表单提交成功。";
    }

    public function render(): View
    {
        return view('livewire.test-page');
    }
}
