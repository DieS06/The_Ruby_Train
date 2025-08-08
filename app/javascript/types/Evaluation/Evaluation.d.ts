interface Question {
    id: number;
    statement: string;
    questionType: "single_choice" | "multiple_choice" | "true_false" | "text_input";
    points: number;
    position: number;
    explanation?: string;
    evaluationSectionId: number;
    topicId:number | null;
    answerOptions?: AnswerOption[];
    createdAt: string;
    updatedAt: string;
}

interface AnswerOption {
    id: number;
    optionText: string;
    isCorrect: boolean;
    position: number;
    explanation?: string;
}

interface Evaluation {
    id: number;
    type: "Quiz" | "Exam";
    title: string;
    description: string;
    timeLimit: number;
    state: "draft" | "published" | "archived";
    contentUnitId: number;
    createdBy: string;
    createdAt: string;
    updatedAt: string;
}

export type { Question, Evaluation, AnswerOption };