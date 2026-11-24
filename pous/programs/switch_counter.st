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

(* 1. Tracking active motor *)
IF M1_CMD THEN
    ACTIVE_MOTOR := 1;
ELSIF M2_CMD THEN
    ACTIVE_MOTOR := 2;
ELSE 
    ACTIVE_MOTOR := 0;
END_IF;

(* 2. Counting changes but not the start *)
IF ACTIVE_MOTOR <> 0 THEN
    (* counting changes only if there was a motor active before*)
    IF PREV_ACTIVE_MOTOR <> 0 AND ACTIVE_MOTOR <> PREV_ACTIVE_MOTOR THEN
        SWITCH_COUNT := SWITCH_COUNT + 1;
    END_IF;

    (* Update the previous state in each change *)
    PREV_ACTIVE_MOTOR := ACTIVE_MOTOR;
END_IF;

(* 3. Timing M1 *)
M1_TICK(IN := M1_CMD AND NOT M1_TICK.Q, PT := T#1s);
IF M1_TICK.Q THEN
    M1_RUNTIME := M1_RUNTIME + 1;
END_IF;

(* 4. Timing M2 *)
M2_TICK(IN := M2_CMD AND NOT M2_TICK.Q, PT := T#1s);
IF M2_TICK.Q THEN
    M2_RUNTIME := M2_RUNTIME + 1;
END_IF;

END_PROGRAM
