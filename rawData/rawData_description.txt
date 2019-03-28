rawData.age: age for each participant.

rawData.gender: gender for each participant (m = male, f = female).

rawData.encoding: raw data for each participant during encoding phase.
    Column 1: block number.
    Column 2: cue word for each pair.
    Column 3: target word for each pair.
    Column 4: difficulty for each pair.
    Column 5: save decision, saved vs. unsaved vs. no-choice (half of the pairs have been saved and participant cannot decide whether to save the current pair).

rawData.retrieval: raw data for each participant during retrieval phase.
    Column 1: block number.
    Column 2: cue word for each pair.
    Column 3: target word for each pair.
    Column 4: test type (forced-recall vs. free-choice).
    Column 5: recall performance (1=correct, 0=incorrect)
    Column 6: participant's answer (correct when the answer is the same as the target word).
    Column 7: choice in the free-choice test (1=ask for help, 0=answer) 
    Column 8: difficulty for each pair.
    Column 9: save decision during learning.
    Column 10: confidence type (with hint vs. without hint).
    Column 11: confidence rating (between 0 and 1).