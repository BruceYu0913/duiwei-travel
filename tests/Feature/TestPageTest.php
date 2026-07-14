<?php

namespace Tests\Feature;

use App\Livewire\TestPage;
use Livewire\Livewire;
use Tests\TestCase;

class TestPageTest extends TestCase
{
    public function test_home_page_renders_flux_w0_content(): void
    {
        $this->get('/')
            ->assertOk()
            ->assertSee('W0 本地环境已就绪')
            ->assertSee('打开 TestPage');
    }

    public function test_livewire_form_validates_the_name(): void
    {
        Livewire::test(TestPage::class)
            ->set('name', '')
            ->call('submit')
            ->assertHasErrors(['name' => 'required']);
    }

    public function test_livewire_form_submits_and_displays_the_result(): void
    {
        Livewire::test(TestPage::class)
            ->set('name', 'Bruce')
            ->call('submit')
            ->assertHasNoErrors()
            ->assertSet('result', '你好，Bruce！Livewire 表单提交成功。')
            ->assertSee('验证通过');
    }
}
