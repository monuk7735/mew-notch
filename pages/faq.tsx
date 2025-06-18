import HomeContainer from "@/components/home-container";
import { ReactNode, useState } from "react";
import { FaChevronRight } from "react-icons/fa";

const faqs = [
	{
		question: "What should I do if I encounter a bug or have feedback?",
		answer:
			"If you find a bug or have suggestions, please open an issue on the GitHub repository or contact me directly. Your feedback and contributions are always welcome!",
	},
	{
		question: "Will MewNotch receive more features?",
		answer:
			"Yes! MewNotch is actively developed and new features are planned. If you have ideas or requests, feel free to submit them on GitHub to help shape the future of the app.",
	},
	{
		question: "Is MewNotch really free?",
		answer:
			"Absolutely. MewNotch is 100% free and open source. There are no ads, no tracking, no paywalls, and no hidden catches—just a tool for the community.",
	},
	{
		question: "Does MewNotch collect any data?",
		answer:
			"No. MewNotch does not collect, track, or share any personal data. All your information stays on your device.",
	},
	{
		question: "Which MacBooks are supported?",
		answer:
			"MewNotch is designed for MacBooks with a notch (M1/M2/M3 MacBook Pro and Air). It can also run on older Macs and Macs without a notch, but the notch overlay may cover menu bar icons or not appear as intended on those devices.",
	},
	{
		question: "Can I customize what appears in the notch?",
		answer:
			"Yes! MewNotch is customizable. You can choose which system indicators to show and adjust their appearance in the app settings.",
	},
	{
		question: "How do I install MewNotch?",
		answer:
			"Visit the GitHub Releases page and download the latest DMG file for macOS. Drag the app to your Applications folder to install.",
	},
	{
		question: "Can I support the project?",
		answer:
			"MewNotch is free, but you can support the project by starring the GitHub repo, sharing it with friends, or buying me a beer from the Support page!",
	},
];

function Accordion({
	faqs,
}: {
	faqs: {
		question: string;
		answer: string;
	}[];
}) {
	const [openIdx, setOpenIdx] = useState<number | null>(null);

	return (
		<div className="w-full max-w-2xl mx-auto flex flex-col gap-4">
			{faqs.map((faq, idx) => (
				<div key={idx} className="rounded-xl">
					<button
						className="w-full flex flex-col p-5 text-left text-white focus:outline-none hover:bg-gray-900/10 transition rounded-xl"
						onClick={() => setOpenIdx(openIdx === idx ? null : idx)}
						aria-expanded={openIdx === idx}
						aria-controls={`faq-panel-${idx}`}
					>
                        <div className="flex justify-between items-center text-lg font-semibold">
                            <span>{faq.question}</span>
                            <FaChevronRight
                                className={`ml-4 transition-transform duration-300 ${openIdx === idx ? "rotate-90" : "rotate-0"
                                    }`}
                                size={16}
                            />
                        </div>

                        <div
						id={`faq-panel-${idx}`}
						className={`overflow-hidden transition-all duration-500 ${
							openIdx === idx ? "max-h-40 pt-4 opacity-100" : "max-h-0 pt-0 opacity-0"
						}`}
						style={{ color: "#d1d5db" }}
						aria-hidden={openIdx !== idx}
					>
						<div>{faq.answer}</div>
					</div>
                    </button>
				</div>
			))}
		</div>
	);
}

export default function FAQ() {
	return (
		<div className="flex flex-col items-center justify-center min-h-[70vh] p-8 lg:p-16 gap-8">
			<h1 className="text-4xl font-bold text-white mb-4 text-center">
				Frequently Asked Questions
			</h1>
			<Accordion faqs={faqs} />
		</div>
	);
}

FAQ.getLayout = function getLayout(page: ReactNode) {
	return <HomeContainer>{page}</HomeContainer>;
};
