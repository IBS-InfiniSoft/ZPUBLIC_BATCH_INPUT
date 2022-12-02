class ZCL_PUB_BATCH_INPUT definition
  public
  final
  create public .

public section.

  constants:
    BEGIN OF mcs_dismode,
        back_proc       TYPE ctu_params-dismode VALUE 'N', " Background processing
        disp_err        TYPE ctu_params-dismode VALUE 'E', " Display Errors
        disp_all_scr    TYPE ctu_params-dismode VALUE 'A', " Display all screens
        back_proc_w_dbg TYPE ctu_params-dismode VALUE 'P', " Background processing; debugging possible
      END OF mcs_dismode .
  constants:
    BEGIN OF mcs_updmode,
        sync  TYPE ctu_params-updmode VALUE 'S', " Synchronous
        loc   TYPE ctu_params-updmode VALUE 'L', " Local
        async TYPE ctu_params-updmode VALUE 'A', " Asynchronous
      END OF mcs_updmode .

  methods SET_DYNPRO
    importing
      !IV_PROGRAM type BDC_PROG
      !IV_DYNPRO type BDC_DYNR
      !IV_DYNBEGIN type BDC_START default 'X' .
  methods SET_FIELD
    importing
      !IV_VAL type ANY
      !IV_NAME type FNAM_____4 .
  methods CALL
    importing
      !IV_TCODE type TCODE
      !IS_OPT type CTU_PARAMS optional
    exporting
      !ET_MSG type UAB_T_MESSAGE .
protected section.
private section.

  data MT_BDCDATA type TAB_BDCDATA .

  methods _FREE .
ENDCLASS.



CLASS ZCL_PUB_BATCH_INPUT IMPLEMENTATION.


  METHOD CALL.

    DATA ls_opt TYPE ctu_params.

    CLEAR: et_msg[].

    IF iv_tcode IS INITIAL.
      RETURN.
    ENDIF.

    IF is_opt IS INITIAL.
      ls_opt-dismode = mcs_dismode-back_proc.
      ls_opt-updmode = mcs_updmode-sync.
    ELSE.
      ls_opt = is_opt.
    ENDIF.

    TRY.
        CALL TRANSACTION iv_tcode
          WITH AUTHORITY-CHECK
          USING mt_bdcdata
          OPTIONS FROM ls_opt
          MESSAGES INTO et_msg.
      CATCH cx_sy_authorization_error.
        me->_free( ).
        RETURN.
    ENDTRY.

    me->_free( ).

  ENDMETHOD.


  METHOD set_dynpro.

    APPEND VALUE bdcdata( program   = iv_program
                          dynpro    = iv_dynpro
                          dynbegin  = iv_dynbegin
                          fnam      = ''
                          fval      = '' ) TO mt_bdcdata.

  ENDMETHOD.


  METHOD set_field.

    DATA lv_val TYPE bdc_fval.

    IF iv_val IS NOT INITIAL.
      DATA(lo_type) = cl_abap_datadescr=>describe_by_data( iv_val ).
      CASE lo_type->type_kind.
        WHEN cl_abap_datadescr=>typekind_date.
          WRITE iv_val TO lv_val DD/MM/YYYY.
        WHEN cl_abap_datadescr=>typekind_packed.
          WRITE iv_val TO lv_val DECIMALS lo_type->decimals LEFT-JUSTIFIED.
        WHEN OTHERS.
          lv_val = iv_val.
      ENDCASE.
    ENDIF.

    APPEND VALUE bdcdata( fnam = iv_name
                          fval = lv_val ) TO mt_bdcdata.

  ENDMETHOD.


  METHOD _free.

    FREE: mt_bdcdata.

  ENDMETHOD.
ENDCLASS.
