import { useMutation } from "@apollo/client";
import { COMPLETE_CONTENT_UNIT } from "../apollo/mutations/progress/completeContentUnit";

export const useCompleteContentUnit = () => {
  const [mutate, state] = useMutation(COMPLETE_CONTENT_UNIT, {
    onCompleted: ({ completeContentUnit }) => {
      // 1) toast / snackbar
      // 2) actualizar store de progreso, si tienes uno
      console.info(
        "Nuevo % del curso:",
        completeContentUnit.courseCompletion
      );
    },
  });

  return {
    complete: (id: string) => mutate({ variables: { id } }),
    ...state, // loading, error, data
  };
};
