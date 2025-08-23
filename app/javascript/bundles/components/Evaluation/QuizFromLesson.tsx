import React, { useState } from "react";
import { useMutation } from "@apollo/client";
import { GENERATE_EVALUATION } from "../../../apollo/mutations/evaluation/generateEvaluation";
import { visit } from "@hotwired/turbo";

type Props = {
  contentUnitId: number;
  topics: string[];
  materialIds?: number[];
  count?: number;
  difficulty?: string;
  language?: string;
  kind?: "quiz" | "exam";
};

export default function QuizFromLesson({
  contentUnitId,
  topics,
  materialIds = [],
  count = 12,
  difficulty = "beginner",
  language = "en",
  kind = "quiz",
}: Props) {
  const [ generating, setGenerating ] = useState(false);
  const [ generate ] = useMutation(GENERATE_EVALUATION);

  const onGenerate = async () => {
    try {
      setGenerating(true);
      const { data } = await generate({
        variables: {
          topics,
          kind,
          contentUnitId,
          materialIds,
          count,
          difficulty,
          language,
        },
      });
      const payload = data?.generateEvaluation;
      if (payload?.evaluationId) {
        visit(`/evaluations?id=${payload.evaluationId}`);
      } else {
        alert(`Could not generate: ${payload?.errors?.join(", ") || "unknown error"}`);
      }
    } finally {
      setGenerating(false);
    }
  };

  return (
    <div className="quiz-from-lesson">
      <button
        className="btn btn-primary"
        disabled={generating || topics.length === 0}
        onClick={onGenerate}
        title="Generate a quiz for the last 4 lessons"
      >
        {generating ? "Generating quiz…" : "Take Quiz for this Segment"}
      </button>
    </div>
  );
}
