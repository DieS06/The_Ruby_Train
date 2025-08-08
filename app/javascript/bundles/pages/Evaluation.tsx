import React, { useEffect } from "react";
import AuthGate from "../components/Wrappers/AuthGate";
import DashboardLayout from "../layouts/Dashboard";
import { EvaluationDashboard } from "../components/Evaluation/EvaluationDashboard";
import Spinner from "../components/Loading/Spinner";

import { useQuery } from '@apollo/client';
import { GET_EVALUATION } from '../../apollo/queries/evaluation/getEvaluation';
import { useEvaluation } from '../../stores/useEvaluation';

interface Props { evaluationId: string; }

const Evaluation: React.FC<Props> = ({ evaluationId }) => {
    const { data, loading, error } = useQuery(GET_EVALUATION, {variables: { evaluationId } });
    
    const setCurrentEvaluation = useEvaluation((s) => s.setCurrentEvaluation);
    const setEvaluation = useEvaluation((s) => s.setEvaluation);
    
    useEffect(() => {
        if (data?.evaluation) {
        setCurrentEvaluation(data.evaluation);
        setEvaluation(data.evaluation);
        }
    }, [data, setCurrentEvaluation, setEvaluation]);
        
    if (loading) return <Spinner />;
    if (error) return <p>Error: {error.message}</p>;
    if (!data?.evaluation) return null;

    return (
        <AuthGate>
        <DashboardLayout userRole={[]}>
            <EvaluationDashboard />
        </DashboardLayout>
        </AuthGate>
    );
}

export default Evaluation;