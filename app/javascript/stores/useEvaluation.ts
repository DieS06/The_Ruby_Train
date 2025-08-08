import { create } from "zustand";
import type { Question, Evaluation } from "../types/Evaluation/Evaluation";

interface EvaluationState {
  questions: Question[];
  evaluation: Evaluation | null;

  filterTopicId: number | null;

  setEvaluation: (ev: Evaluation) => void;
  addQuestion: (q: Question) => void;
  removeQuestion: (id: number) => void;
  moveQuestion: (from: number, to: number) => void;
  setFilter: (topicId: number | null) => void;

  currentEvaluation: Evaluation | null;
  setCurrentEvaluation: (ev: Evaluation) => void;
}

const useEvaluation = create<EvaluationState>()((set) => ({
  questions: [],
  evaluation: null,
  filterTopicId: null,
  currentEvaluation: null,

  setEvaluation: (ev) => set({ evaluation: ev, questions: ev.questions }),

  addQuestion: (q) =>
    set((s) => ({
      questions: [...s.questions, q],
    })),

  removeQuestion: (id) =>
    set((s) => ({
      questions: s.questions.filter((q) => q.id !== id),
    })),

  moveQuestion: (from, to) =>
    set((s) => {
      const updated = [...s.questions];
      const [item] = updated.splice(from, 1);
      updated.splice(to, 0, item);
      return { questions: updated };
    }),

  setFilter: (topicId) => set({ filterTopicId: topicId }),

  setCurrentEvaluation: (ev) => set({ currentEvaluation: ev }),
}));

export { useEvaluation };