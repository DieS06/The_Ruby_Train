import React from "react";
import type { Question } from "../../../types/Evaluation/Evaluation";
import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import "../../../styles/components/Evaluation/EvaluationCard.scss";

interface Props {
  question: Question;
  index: number;
}

const EvaluationCard: React.FC<Props> = ({ question }) => {
    const { attributes, listeners, setNodeRef, transform, transition } = useSortable({ id: question.id });

    const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    };

    return (
        <article 
        ref={setNodeRef}
        style={style}
        {...attributes}
        {...listeners}
        className="evaluation-card"
        >
            <span className="evaluation-card-statement">{question.statement}</span>
            <span className="evaluation-card-points">{question.points} pt</span>
        </article>
    );
};

export { EvaluationCard };
