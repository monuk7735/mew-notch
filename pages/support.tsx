import HomeContainer from "@/components/home-container";
import { ReactNode } from "react";

export default function Support() {
  return (
    <div className="flex flex-col items-center justify-center min-h-[70vh] p-8 gap-8">
      <div className="max-w-2xl text-center text-lg text-gray-300 flex flex-col gap-6">
        <p className="pb-10">
          <span className="text-2xl md:text-3xl font-extrabold text-blue-400 block mb-2">MewNotch is completely free and open source.</span>
          <span className="text-xl font-semibold text-white block mb-2">You don&apos;t owe me anything for using it.</span>
          <span className="text-base text-gray-400">No ads, no tracking, no paywalls, and no hidden catches—just a tool for the community.</span>
        </p>
        <p>
          If you find MewNotch useful, the best way to support me is to <span className="text-blue-400 font-semibold">star the GitHub repo</span> and {" "}
          <span className="inline-flex items-center gap-1 text-blue-400 font-semibold">
            share it with your friends
          </span>
          {" "}by word of mouth or online.
          <br/>
          <br/>
          Your feedback, bug reports, and contributions are always welcome!
        </p>
        <div className="flex flex-col items-center gap-2 pt-16">
          <span className="text-gray-400">But if you really want to show appreciation...</span>
          <a
            href="https://coff.ee/monuk7735"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-6 py-3 rounded-lg bg-yellow-400 hover:bg-yellow-300 text-black font-bold shadow transition-colors duration-200 text-lg mt-2"
          >
            🍺 Buy me a beer
          </a>
        </div>
      </div>
    </div>
  );
}

Support.getLayout = function getLayout(page: ReactNode) {
  return <HomeContainer>{page}</HomeContainer>;
};
