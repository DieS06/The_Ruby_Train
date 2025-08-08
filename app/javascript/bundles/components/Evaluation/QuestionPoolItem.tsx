import React from "react";
import { useDraggable } from "@dnd-kit/core";
import type { Question } from "../../../types/Evaluation/Evaluation";

const QuestionPoolItem: React.FC<{ question: Question }> = ({ question }) => {
  const { setNodeRef, attributes, listeners } = useDraggable({
    id: `pool-${question.id}`,
    data: { question },
  });

  return (
    <li
      ref={setNodeRef}
      {...attributes}
      {...listeners}
      className="question-pool-item"
    >
      {question.statement}
    </li>
  );
};

export  { QuestionPoolItem };
