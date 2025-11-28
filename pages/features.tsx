import HomeContainer from "@/components/home-container";
import { ReactNode, useState, useRef, useEffect } from "react";
import Head from "next/head";
import Image from "next/image";
import nextConfig from "../next.config";
import { FaHeadphones, FaBatteryFull, FaLock, FaMusic, FaDesktop, FaFolderOpen } from "react-icons/fa";

const designVariants = {
    brightness: {
        label: "Brightness",
        items: [
            { name: "Minimal", src: "/preview/brightness/minimal.mp4" },
            { name: "Progress Bar", src: "/preview/brightness/progress.mp4" },
            { name: "Notched", src: "/preview/brightness/notched.mp4" },
        ]
    },
    speaker: {
        label: "Speaker",
        items: [
            { name: "Minimal", src: "/preview/speaker/minimal.mp4" },
            { name: "Progress Bar", src: "/preview/speaker/progress.mp4" },
            { name: "Notched", src: "/preview/speaker/notched.mp4" },
        ]
    },
    microphone: {
        label: "Microphone",
        items: [
            { name: "Minimal", src: "/preview/microphone/minimal.mp4" },
            { name: "Progress Bar", src: "/preview/microphone/progress.mp4" },
            { name: "Notched", src: "/preview/microphone/notched.mp4" },
        ]
    }
};

type DesignVariantKey = keyof typeof designVariants;

const features = [
    {
        icon: <FaHeadphones />,
        title: "Sound Device Switching",
        description: "Know exactly which device is active. MewNotch notifies you immediately when your input or output audio device changes, so you're never caught off guard.",
        media: "/preview/media/device-changes.mp4",
        type: "video"
    },
    {
        icon: <FaBatteryFull />,
        title: "Power State & Battery",
        description: "Keep an eye on your power. View your current charging status and remaining battery time at a glance, integrated seamlessly into the notch area.",
        media: "/preview/power.mp4",
        type: "video"
    },
    {
        icon: <FaMusic />,
        title: "Now Playing Control",
        description: "Control your media effortlessly. See what's playing and control playback directly from the notch. Expand it for even more controls and details.",
        media: "/preview/media/music-player.mp4",
        type: "video"
    },
    {
        icon: <FaFolderOpen />,
        title: "File Shelf",
        description: "Keep your essential files handy. The File Shelf allows you to drag and drop files into the notch for quick access later.",
        media: "/preview/file-shelf.mp4",
        type: "video",
        aspectClass: "aspect-[32/9]"
    },
    {
        icon: <FaDesktop />,
        title: "Multi-Display Support",
        description: "Full control over where the notch appears. Choose specific monitors or have it on all of them. Customize the experience for each display.",
        media: "/preview/multi-display-setup.png",
        type: "image"
    },
    {
        icon: <FaLock />,
        title: "Notch on Lock Screen",
        description: "Why lose utility when locked? The notch HUD remains visible and functional even on the macOS lock screen, providing consistent feedback at all times.",
        media: "/preview/lockscreen.jpg",
        type: "image"
    }
];

function DesignShowcase({ assetPrefix }: { assetPrefix: string }) {
    const [activeTab, setActiveTab] = useState<DesignVariantKey>('brightness');
    const [activeIndex, setActiveIndex] = useState(0);
    const scrollContainerRef = useRef<HTMLDivElement>(null);

    // Reset active index when tab changes
    useEffect(() => {
        setActiveIndex(0);
        if (scrollContainerRef.current) {
            scrollContainerRef.current.scrollTo({ left: 0, behavior: 'smooth' });
        }
    }, [activeTab]);

    const handleScroll = () => {
        if (scrollContainerRef.current) {
            const { scrollLeft, clientWidth } = scrollContainerRef.current;
            const index = Math.round(scrollLeft / clientWidth);
            setActiveIndex(index);
        }
    };

    return (
        <div className="w-full max-w-7xl px-6 md:px-12 py-10 space-y-12 mb-20">
            <div className="text-center space-y-4">
                <h2 className="text-3xl md:text-5xl font-bold text-gray-900 dark:text-white">
                    Choose Your Style
                </h2>
                <p className="text-xl text-gray-600 dark:text-gray-300">
                    Three distinct design languages to match your aesthetic.
                </p>
            </div>

            {/* Tabs */}
            <div className="flex justify-center gap-4 flex-wrap" role="tablist">
                {Object.entries(designVariants).map(([key, { label }]) => (
                    <button
                        key={key}
                        role="tab"
                        aria-selected={activeTab === key}
                        aria-controls="design-showcase-panel"
                        onClick={() => setActiveTab(key as DesignVariantKey)}
                        className={`px-6 py-3 rounded-full font-semibold transition-all duration-200 ${activeTab === key
                            ? 'bg-blue-500 text-white shadow-lg scale-105'
                            : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
                            }`}
                    >
                        {label}
                    </button>
                ))}
            </div>

            {/* Grid / Viewpager */}
            <div
                id="design-showcase-panel"
                role="tabpanel"
                ref={scrollContainerRef}
                onScroll={handleScroll}
                className="flex md:flex-wrap md:justify-center gap-8 overflow-x-auto snap-x snap-mandatory md:snap-none pb-4 md:pb-0 -mx-6 px-6 md:mx-0 md:px-0 scrollbar-hide"
            >
                {designVariants[activeTab].items.map((item, idx) => (
                    <div
                        key={idx}
                        className="flex flex-col items-center gap-4 group min-w-[85vw] md:min-w-[280px] md:w-[30%] snap-center"
                        style={{ scrollSnapStop: 'always' }}
                    >
                        <div className="relative w-full aspect-[16/10] rounded-2xl overflow-hidden bg-gray-100 dark:bg-gray-800 shadow-lg border border-gray-200 dark:border-gray-700">
                            <video
                                key={item.src}
                                autoPlay
                                loop
                                muted
                                playsInline
                                aria-hidden="true"
                                className="absolute inset-0 w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                            >
                                <source src={`${assetPrefix}${item.src}`} type="video/mp4" />
                            </video>
                        </div>
                        <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                            {item.name}
                        </h3>
                    </div>
                ))}
            </div>

            {/* Mobile Dots Indicator */}
            <div className="flex justify-center gap-2 md:hidden">
                {designVariants[activeTab].items.map((_, idx) => (
                    <div
                        key={idx}
                        className={`w-2 h-2 rounded-full transition-all duration-300 ${activeIndex === idx
                            ? 'bg-blue-500 w-6'
                            : 'bg-gray-300 dark:bg-gray-700'
                            }`}
                    />
                ))}
            </div>
            <style jsx global>{`
                .scrollbar-hide::-webkit-scrollbar {
                    display: none;
                }
                .scrollbar-hide {
                    -ms-overflow-style: none;
                    scrollbar-width: none;
                }
            `}</style>
        </div>
    );
}

export default function Features() {
    const assetPrefix = nextConfig.basePath || "";

    return (
        <>
            <Head>
                <title>Features - MewNotch</title>
            </Head>
            <div className="flex flex-col items-center min-h-screen pb-20">
                {/* Hero Section */}
                <div className="w-full py-20 px-8 text-center space-y-6">
                    <h1 className="text-4xl md:text-6xl font-bold text-gray-900 dark:text-white tracking-tight">
                        Powerful Features. <br />
                        <span className="text-blue-500 dark:text-blue-400">Minimal Design.</span>
                    </h1>
                    <p className="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto leading-relaxed">
                        MewNotch transforms that empty space into your Mac&apos;s most useful utility.
                        Discover everything it can do.
                    </p>
                </div>

                {/* Design Showcase */}
                <DesignShowcase assetPrefix={assetPrefix} />

                {/* Staggered Features List */}
                <div className="w-full max-w-7xl px-6 md:px-12 flex flex-col gap-24">
                    {features.map((feature, idx) => (
                        <div
                            key={idx}
                            className={`flex flex-col md:flex-row items-center gap-12 md:gap-24 ${idx % 2 === 1 ? 'md:flex-row-reverse' : ''}`}
                        >
                            {/* Text Side */}
                            <div className="flex-1 space-y-6 text-center md:text-left">
                                <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-3xl mb-2" aria-hidden="true">
                                    {feature.icon}
                                </div>
                                <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white">
                                    {feature.title}
                                </h2>
                                <p className="text-lg text-gray-600 dark:text-gray-300 leading-relaxed">
                                    {feature.description}
                                </p>
                            </div>

                            {/* Image/Video Side */}
                            <div className="flex-1 w-full">
                                <div className={`relative ${feature.aspectClass || 'aspect-video'} w-full rounded-2xl overflow-hidden shadow-2xl border border-gray-200 dark:border-gray-800 group`}>
                                    <div className="absolute inset-0 bg-gradient-to-tr from-blue-500/10 to-purple-500/10 dark:from-blue-500/20 dark:to-purple-500/20 z-10 pointer-events-none" />
                                    {feature.type === 'video' ? (
                                        <video
                                            autoPlay
                                            loop
                                            muted
                                            playsInline
                                            className="absolute inset-0 w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                                        >
                                            <source src={`${assetPrefix}${feature.media}`} type="video/mp4" />
                                        </video>
                                    ) : (
                                        <Image
                                            src={`${assetPrefix}${feature.media}`}
                                            alt={feature.title}
                                            fill
                                            className="object-cover object-top transition-transform duration-500 group-hover:scale-105 scale-"
                                        />
                                    )}
                                </div>
                            </div>
                        </div>
                    ))}
                </div>

                {/* Bottom CTA */}
                <div className="mt-32 text-center space-y-8">
                    <h2 className="text-3xl font-bold text-gray-900 dark:text-white">
                        Ready to upgrade your notch?
                    </h2>
                    <a
                        href="https://github.com/monuk7735/mew-notch/releases"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-2 px-8 py-4 rounded-full bg-blue-500 hover:bg-blue-600 text-white font-bold shadow-lg hover:shadow-xl transition-all duration-200 text-xl"
                    >
                        Download for macOS
                    </a>
                </div>
            </div>
        </>
    );
}

Features.getLayout = function getLayout(page: ReactNode) {
    return <HomeContainer>{page}</HomeContainer>;
};
