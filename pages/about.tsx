import HomeContainer from "@/components/home-container";
import { ReactNode } from "react";
import Head from "next/head";
import { FaCode, FaHeart, FaUserSecret } from "react-icons/fa";

export default function About() {
  return (
    <>
      <Head>
        <title>About - MewNotch</title>
      </Head>
      <div className="flex flex-col items-center justify-center min-h-[70vh] px-6 py-20 max-w-4xl mx-auto w-full">

        <div className="text-center space-y-6 mb-16">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white">
            Simple. Private. Open.
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto leading-relaxed">
            MewNotch was built with a philosophy of transparency and respect for the user.
            No hidden agendas, just a great utility for your Mac.
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8 w-full">
          {/* Privacy First */}
          <div className="bg-white/50 dark:bg-gray-800/50 backdrop-blur-sm p-8 rounded-2xl border border-gray-200 dark:border-gray-700 flex flex-col items-center text-center gap-4 hover:scale-105 transition-transform duration-300">
            <div className="w-14 h-14 rounded-full bg-green-100 dark:bg-green-900/30 flex items-center justify-center text-green-600 dark:text-green-400 text-2xl" aria-hidden="true">
              <FaUserSecret />
            </div>
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Privacy First</h3>
            <p className="text-gray-600 dark:text-gray-300">
              No tracking. No analytics. No data collection. Your usage stays on your device, where it belongs.
            </p>
          </div>

          {/* Open Source */}
          <div className="bg-white/50 dark:bg-gray-800/50 backdrop-blur-sm p-8 rounded-2xl border border-gray-200 dark:border-gray-700 flex flex-col items-center text-center gap-4 hover:scale-105 transition-transform duration-300">
            <div className="w-14 h-14 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-2xl" aria-hidden="true">
              <FaCode />
            </div>
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Open Source</h3>
            <p className="text-gray-600 dark:text-gray-300">
              The code is fully open for inspection on GitHub. Built by the community, for the community.
            </p>
          </div>

          {/* Completely Free */}
          <div className="bg-white/50 dark:bg-gray-800/50 backdrop-blur-sm p-8 rounded-2xl border border-gray-200 dark:border-gray-700 flex flex-col items-center text-center gap-4 hover:scale-105 transition-transform duration-300">
            <div className="w-14 h-14 rounded-full bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center text-purple-600 dark:text-purple-400 text-2xl" aria-hidden="true">
              <FaHeart />
            </div>
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Forever Free</h3>
            <p className="text-gray-600 dark:text-gray-300">
              MewNotch is free to use. No subscriptions, no paywalls, no &quot;Pro&quot; version. Just download and enjoy.
            </p>
          </div>
        </div>

      </div>
    </>
  );
}

About.getLayout = function getLayout(page: ReactNode) {
  return <HomeContainer>{page}</HomeContainer>;
};
