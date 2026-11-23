PROGRAM switch_counter
  VAR_EXTERNAL
    ACTIVE_MOTOR : INT;
    SWITCH_COUNT : INT;
    PREV_ACTIVE_MOTOR : INT;
    M1_CMD : BOOL;
    M2_CMD : BOOL;
  END_VAR
  VAR
    M1_TICK : TON;
    M2_TICK : TON;
    M1_RUNTIME : DINT;
    M2_RUNTIME : DINT;
  END_VAR

(* 1. Εντοπισμός ενεργού μοτέρ *)
IF M1_CMD THEN
    ACTIVE_MOTOR := 1;
ELSIF M2_CMD THEN
    ACTIVE_MOTOR := 2;
ELSE 
    ACTIVE_MOTOR := 0;
END_IF;

(* 2. Καταμέτρηση εναλλαγών χωρίς την πρώτη εκκίνηση *)
IF ACTIVE_MOTOR <> 0 THEN
    (* Μετράμε εναλλαγή μόνο αν υπήρχε ήδη ενεργό μοτέρ πριν (όχι από 0) *)
    IF PREV_ACTIVE_MOTOR <> 0 AND ACTIVE_MOTOR <> PREV_ACTIVE_MOTOR THEN
        SWITCH_COUNT := SWITCH_COUNT + 1;
    END_IF;

    (* Ενημέρωση της προηγούμενης κατάστασης σε κάθε αλλαγή *)
    PREV_ACTIVE_MOTOR := ACTIVE_MOTOR;
END_IF;

(* 3. Χρονομέτρηση M1 *)
M1_TICK(IN := M1_CMD AND NOT M1_TICK.Q, PT := T#1s);
IF M1_TICK.Q THEN
    M1_RUNTIME := M1_RUNTIME + 1;
END_IF;

(* 4. Χρονομέτρηση M2 *)
M2_TICK(IN := M2_CMD AND NOT M2_TICK.Q, PT := T#1s);
IF M2_TICK.Q THEN
    M2_RUNTIME := M2_RUNTIME + 1;
END_IF;

END_PROGRAM