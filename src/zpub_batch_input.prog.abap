*&---------------------------------------------------------------------*
*& Report ZPUB_BATCH_INPUT
*&---------------------------------------------------------------------*
*& Call transaction with BDC
*&---------------------------------------------------------------------*
REPORT zpub_batch_input.
INCLUDE zpub_batch_input_c01.

START-OF-SELECTION.
  lcl_demo=>main( ).
