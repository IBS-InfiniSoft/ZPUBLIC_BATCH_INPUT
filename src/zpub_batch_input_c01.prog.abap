*&---------------------------------------------------------------------*
*& Include          ZPUB_BATCH_INPUT_C01
*&---------------------------------------------------------------------*
CLASS lcl_demo DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.

    DATA(lo_bdc) = NEW zcl_pub_batch_input( ).
    lo_bdc->set_dynpro( EXPORTING iv_dynpro   = '0100'
                                  iv_program  = 'SAPMF05L'
                                  iv_dynbegin = abap_true ).

    lo_bdc->set_field( EXPORTING iv_name = 'BDC_OKCODE'
                                 iv_val  = '=SRCH' ).

    lo_bdc->set_dynpro( EXPORTING iv_dynpro  = '1000'
                                  iv_program = 'RFBUEB00' ).

    lo_bdc->set_field( EXPORTING iv_val  = '0001'
                                 iv_name = 'BR_BUKRS-LOW' ).

    lo_bdc->set_field( EXPORTING iv_val  = CONV syst_datum( '20180914' )
                                 iv_name = 'BR_BUDAT-LOW' ).

    lo_bdc->set_field( EXPORTING iv_name = 'BDC_OKCODE'
                                 iv_val  = '=ONLI' ).

    lo_bdc->call( EXPORTING is_opt = VALUE #( dismode = zcl_pub_batch_input=>mcs_dismode-disp_err " display errors
                                              updmode = zcl_pub_batch_input=>mcs_updmode-sync     " synchronous
                                              defsize = abap_true )                               " default screen size
                                        iv_tcode = 'FB03'
                              IMPORTING et_msg = DATA(lt_msg) ).
  ENDMETHOD.
ENDCLASS.
