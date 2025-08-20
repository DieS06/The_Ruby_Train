import React from "react";
import { DndContext, closestCenter, DragEndEvent } from "@dnd-kit/core";
import { SortableContext, verticalListSortingStrategy } from "@dnd-kit/sortable";
import { useEvaluation } from "../../../stores/useEvaluation";
import { QuestionPool } from "./QuestionPool";
import { EvaluationCard } from "./EvaluationCard";
import type { Question } from "../../../types/Evaluation/Evaluation";
import "../../../styles/components/Evaluation/EvaluationDashboard.scss";

const EvaluationDashboard: React.FC = () => {
    const { questions, moveQuestion, addQuestion, currentEvaluation, } = useEvaluation();

    const contentUnitId = currentEvaluation?.content_unit_id;

    const handleDragEnd = (event: DragEndEvent) => {
        const { active, over } = event;
        if (!over) return;

    if (String(active.id).startsWith("pool-")) {
        const q: Question | undefined = active.data.current?.question;
        if (q) addQuestion({ ...q, id: Date.now() });
        return;
        }

        if (active.id !== over.id) {
        const oldIdx = questions.findIndex((q) => q.id === active.id);
        const newIdx = questions.findIndex((q) => q.id === over.id);
        moveQuestion(oldIdx, newIdx);
        }
    };

  return (
    <section className="eval-dashboard">
      <section className="editor">
        <header className="editor-header">
          <h2> Editor</h2>
        </header>

        <DndContext 
            collisionDetection={closestCenter} 
            onDragEnd={handleDragEnd}
        >
            <SortableContext 
                items={questions.map((q) => q.id)} 
                strategy={verticalListSortingStrategy}
            >
                {questions.map((q: Question) => (
                    <EvaluationCard key={q.id} question={q} index={q.position} />
                ))}
            </SortableContext>
        </DndContext>
      </section>

      <aside className="question-pool">
        {contentUnitId && <QuestionPool contentUnitId={contentUnitId} />}
      </aside>
    </section>
  );
};

export { EvaluationDashboard };
