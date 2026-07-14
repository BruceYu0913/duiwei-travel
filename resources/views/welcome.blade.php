<x-layouts.app title="对味 DUIWEI · W0 已就绪">
    <main class="min-h-screen overflow-hidden bg-[#fff8ee] text-zinc-900 dark:bg-zinc-950 dark:text-zinc-100">
        <section class="relative mx-auto grid min-h-screen max-w-7xl items-center gap-12 px-6 py-16 lg:grid-cols-[1.05fr_.95fr] lg:px-10">
            <div class="relative z-10">
                <flux:badge color="orange">W0 本地环境已就绪</flux:badge>

                <p class="mt-7 text-xs font-bold tracking-[0.24em] text-orange-600">DUIWEI · 美食社交旅行平台</p>
                <h1 class="mt-5 max-w-3xl text-5xl font-black leading-[1.02] tracking-[-0.06em] sm:text-7xl">
                    找到同频旅伴，<span class="text-orange-600">一起吃遍一座城。</span>
                </h1>
                <p class="mt-7 max-w-xl text-lg leading-8 text-zinc-600 dark:text-zinc-300">
                    Laravel 11、Livewire 3、FluxUI、Tailwind CSS 4 与 MySQL 8 已完成初始化。下一步从可交互的 TestPage 开始。
                </p>

                <div class="mt-9 flex flex-wrap gap-3">
                    <flux:button href="{{ route('test-page') }}" variant="primary" icon:trailing="arrow-right">
                        打开 TestPage
                    </flux:button>
                    <flux:button href="{{ route('prototype') }}" variant="ghost" icon:trailing="arrow-up-right">
                        查看原始原型
                    </flux:button>
                </div>
            </div>

            <div class="relative min-h-[460px]">
                <div class="absolute -right-28 top-0 size-80 rounded-full bg-orange-400/70 blur-2xl"></div>
                <div class="absolute left-0 top-10 w-[min(100%,430px)] -rotate-3 rounded-3xl border-2 border-zinc-900 bg-white p-7 shadow-[10px_10px_0_#1d1a19] dark:border-zinc-200 dark:bg-zinc-900 dark:shadow-[10px_10px_0_#ffc92d]">
                    <div class="flex items-center justify-between">
                        <span class="text-5xl">🍜</span>
                        <flux:badge color="emerald">环境健康</flux:badge>
                    </div>
                    <h2 class="mt-7 text-3xl font-black tracking-tight">成都 · 火锅漫游</h2>
                    <p class="mt-2 text-zinc-600 dark:text-zinc-300">3 天 2 夜 · 同频旅伴正在集合</p>
                    <div class="mt-7 flex flex-wrap gap-2">
                        @foreach (['能吃辣', '慢节奏', '街巷探索'] as $tag)
                            <span class="rounded-full border border-zinc-800 bg-emerald-100 px-3 py-1.5 text-sm font-semibold text-zinc-900">{{ $tag }}</span>
                        @endforeach
                    </div>
                </div>

                <div class="absolute bottom-8 right-0 w-64 rotate-6 rounded-2xl border-2 border-zinc-900 bg-amber-300 p-5 shadow-[7px_7px_0_#1d1a19]">
                    <p class="text-xs font-bold tracking-widest">W0 CHECKLIST</p>
                    <ul class="mt-4 space-y-2 text-sm font-semibold">
                        <li>✓ Laravel / Livewire</li>
                        <li>✓ FluxUI / Tailwind</li>
                        <li>✓ MySQL migrations</li>
                        <li>✓ Vite production build</li>
                    </ul>
                </div>
            </div>
        </section>
    </main>
</x-layouts.app>
