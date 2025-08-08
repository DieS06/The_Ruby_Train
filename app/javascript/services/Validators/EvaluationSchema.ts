import { z } from "zod";

const answerOptionSchema = z.object({
  optionText: z.string().min(1, "Option text required"),
  isCorrect: z.boolean(),
  id: z.number().optional(),
  position: z.number().optional(),
});

const questionSchema = z
  .object({
    statement: z.string().min(5, "The statement must be at least 5 characters"),
    questionType: z.enum([
      "single_choice",
      "multiple_choice",
      "true_false",
      "text_input",
    ]),
    points: z.number().int().min(1, "Points must be ≥ 1"),
    answerOptions: z.array(answerOptionSchema).nonempty("At least one option"),

    id: z.number().optional(),
    position: z.number().optional(),
    evaluationSectionId: z.number().optional(),
    topicId: z.number().nullable().optional(),
    createdAt: z.string().optional(),
    updatedAt: z.string().optional(),
  })
  .superRefine((data, ctx) => {
    const correct = data.answerOptions.filter((o) => o.isCorrect).length;

    if (["single_choice", "true_false"].includes(data.questionType) && correct !== 1) {
      ctx.addIssue({
        path: ["answerOptions"],
        message: "Exactly one option must be correct",
        code: z.ZodIssueCode.custom,
      });
    }

    if (data.questionType === "multiple_choice" && correct < 1) {
      ctx.addIssue({
        path: ["answerOptions"],
        message: "Select at least one correct option",
        code: z.ZodIssueCode.custom,
      });
    }
  });

export { questionSchema, answerOptionSchema };