<div class="min-h-screen bg-[#fff8ee] px-6 py-12 text-zinc-900 dark:bg-zinc-950 dark:text-zinc-100 sm:px-10">
    <div class="mx-auto max-w-2xl">
        <a href="{{ route('home') }}" class="text-sm font-medium text-orange-600 hover:text-orange-700">← 返回首页</a>

        <div class="mt-8 rounded-3xl border-2 border-zinc-900 bg-white p-7 shadow-[8px_8px_0_#ffc92d] dark:border-zinc-200 dark:bg-zinc-900 sm:p-10">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <flux:badge color="orange">Livewire 3 + FluxUI</flux:badge>
                <span class="text-xs font-semibold tracking-widest text-zinc-500">W0 TEST PAGE</span>
            </div>

            <flux:heading size="xl" level="1" class="mt-6">组件热身页</flux:heading>
            <flux:text class="mt-3">填写表单并提交。页面不刷新、结果即时出现，即表示 Livewire 与 FluxUI 均工作正常。</flux:text>

            <form wire:submit="submit" class="mt-8 space-y-5">
                <flux:input
                    wire:model="name"
                    label="你的名字"
                    placeholder="例如：Bruce"
                    autocomplete="name"
                />

                <flux:button type="submit" variant="primary" icon:trailing="paper-airplane">
                    <span wire:loading.remove wire:target="submit">提交测试</span>
                    <span wire:loading wire:target="submit">正在提交…</span>
                </flux:button>
            </form>

            @if ($result)
                <div data-testid="result" class="mt-7 rounded-2xl border border-emerald-300 bg-emerald-50 p-4 text-emerald-900 dark:border-emerald-700 dark:bg-emerald-950 dark:text-emerald-100">
                    <div class="flex items-center gap-3">
                        <flux:badge color="emerald">验证通过</flux:badge>
                        <p class="font-medium">{{ $result }}</p>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
