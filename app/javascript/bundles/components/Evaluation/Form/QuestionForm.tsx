import React, { useState } from "react";
import { Input } from "../../Accesible_Assets/Input";
import { Checkbox } from "../../Accesible_Assets/Checkbox";
import { TriggerButton } from "../../Accesible_Assets/TriggerButton";
import { SubmitButton } from "../../Accesible_Assets/SubmitButton";
import { SelectField } from "../../Accesible_Assets/SelectField";
import type { Question, AnswerOption } from "../../../../types/Evaluation/Evaluation";
import { useEvaluation } from "../../../../stores/useEvaluation";
import { z } from "zod";
import { questionSchema } from "../../../../services/Validators/EvaluationSchema";
import "../../../../styles/components/Evaluation/Question/QuestionForm.scss";

const optionTemplate = (pos: number): AnswerOption => ({
  id: Date.now() + pos,
  optionText: "",
  isCorrect: false,
  position: pos,
});

interface Props {
  onClose: () => void;
}

const QuestionForm: React.FC<Props> = ({ onClose }) => {
    const addQuestion = useEvaluation((s) => s.addQuestion);
    const [formError, setFormError] = useState<string | null>(null);
    const [statement, setStatement] = useState("");
    const [questionType, setQuestionType] = useState<Question["questionType"]> ("single_choice");
    const [points, setPoints] = useState(1);
    const [options, setOptions] = useState<AnswerOption[]>([
        optionTemplate(1),
        optionTemplate(2),
    ]);

    const updateOption = (idx: number, field: keyof AnswerOption, val: any) =>
        setOptions((arr) => arr.map((o, i) => (i === idx ? { ...o, [field]: val } : o)));

    const toggleCorrect = (idx: number) =>
        setOptions((arr) =>
      arr.map((o, i) => ({
        ...o,
        isCorrect:
          questionType === "single_choice"
            ? i === idx
            : i === idx
            ? !o.isCorrect
            : o.isCorrect,
      })),
    );

  const handleSubmit = () => {
    const parsed = questionSchema.safeParse({
        statement,
        questionType,
        points,
        answerOptions: options,
    });

    if (!parsed.success) {
        setFormError(parsed.error.issues[0].message);
        return;
    }
    
    const now = new Date().toISOString();

    const fullQuestion: Question = {
        ...parsed.data,
        id: Date.now(),
        position: 0,
        evaluationSectionId: 0,
        topicId: null,
        createdAt: now,
        updatedAt: now,
        answerOptions: parsed.data.answerOptions.map((opt, idx) => ({
        ...opt,
        id: opt.id ?? Date.now() + idx,
        position: idx + 1,
        })),
    };

    addQuestion(fullQuestion);
    onClose();
  };

  return (
    <form className="question-form" onSubmit={(e) => e.preventDefault()}>
      <h3>New Question</h3>

      <Input
        placeholder="Question statement"
        name="statement"
        type="text"
        value={statement}
        onChange={(e) => setStatement(e.target.value)}
      />

      <SelectField
        label="Type"
        name="questionType"
        selected={questionType}
        onChange={(val) => setQuestionType(val as Question["questionType"])}
        options={[
          { value: "single_choice", label: "Single choice" },
          { value: "multiple_choice", label: "Multiple choice" },
          { value: "true_false", label: "True / False" },
          { value: "text_input", label: "Text input" },
        ]}
      />

      {["single_choice", "multiple_choice", "true_false"].includes(questionType) && (
        <>
          <h4>Answer options</h4>
          {options.map((opt, idx) => (
            <div key={opt.id} className="option-row">
              <Input
                placeholder={`Option ${idx + 1}`}
                name={`option_${idx}`}
                type="text"
                value={opt.optionText}
                onChange={(e) => updateOption(idx, "optionText", e.target.value)}
              />
              <Checkbox
                name={`correct_${idx}`}
                label="Correct"
                checked={opt.isCorrect}
                onChange={() => toggleCorrect(idx)}
              />
            </div>
          ))}
          <TriggerButton onClick={() => setOptions((o) => [...o, optionTemplate(o.length + 1)])}>
            + Option
          </TriggerButton>
        </>
      )}

      <SubmitButton onPress={handleSubmit}>Save</SubmitButton>
      <TriggerButton onClick={onClose}>Cancel</TriggerButton>

        {formError && (
            <p role="alert" aria-live="assertive" className="form-error">
                {formError}
            </p>
        )}
    </form>
  );
};

export { QuestionForm };
