import React, { useState } from "react";
import { DialogComponent } from "../Accesible_Assets/Dialog";
import { TriggerButton } from "../Accesible_Assets/TriggerButton";
import { useEvaluation } from "../../../stores/useEvaluation";
import { Question } from "@/types/Evaluation/Evaluation";
import { QuestionForm } from "../Evaluation/Form/QuestionForm";
import { QuestionPoolItem } from "./QuestionPoolItem";
import { useQuery } from "@apollo/client";
import { GET_QUESTIONS } from "@/apollo/queries/evaluation/getQuestions";
import "../../../styles/components/Evaluation/Question/QuestionPool.scss";

interface Props {  contentUnitId: number;}

const QuestionPool: React.FC<Props> = ({ contentUnitId }) => {
  const { filterTopicId } = useEvaluation();
  const [isOpen, setIsOpen] = useState(false);

  const { data } = useQuery(GET_QUESTIONS, { 
    variables: { contentUnitId, topicId: filterTopicId } 
  });

  const questions = data?.questions ?? [];

  return (
    <section className="question-pool">
      <header className="question-pool-header">
        <h2 className="question-pool-title">Question Pool</h2>
        <TriggerButton onClick={() => setIsOpen(true)}>+</TriggerButton>
        <h3>New Question</h3>
      </header>

      <ul className="question-pool-list">
        {questions.map((q: Question) => (
          <QuestionPoolItem key={q.id} question={q} />
        ))}
      </ul>

      <DialogComponent
        isOpen={isOpen}
        onOpenChange={setIsOpen}
        ariaLabel="Create Question"
        trigger={null}
      >
        {(close) => <QuestionForm onClose={close} />}
      </DialogComponent>
    </section>
  );
};

export { QuestionPool };
