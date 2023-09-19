CREATE DEFINER=`bowling`@`%` PROCEDURE `SP_GET_ASSIGN_LIST`(
/*****

	[Project]
		bowlingpick 시스템
	[Object Name]
		SP_GET_ASSIGN_LIST
	[Description]
		게임 예약/배정 목록를 조회한다.
        종료된 게임은 제외한다.
	[Parameters]
		=================================================================
		Parameter       Direction   Type		    Decription
        ---------------	-----------	--------------- ---------------------
	    p_store_cd		IN			varchar(5)		사업장 코드
		=================================================================
	[Usage]
		call bowling.SP_GET_GAME_STATUS('A0001');
	[History]
		=================================================================
		Revision	Modified	Writer	Remark
		-----------	-----------	-------	---------------------------------
        1.0.0.7     2023.08.23  이선우    shoes_yn(볼링화 대여 여부) 추가
        1.0.0.6     2023.08.14  이선우    p_assign_dt(배정일자) 삭제
        1.0.0.5     2023.08.03  이선우    membership_use_cnt, membership_use_min 추가
        1.0.0.4     2023.07.21  이선우    membership_seq 추가
        1.0.0.3		2023.07.20	이선우	competition_seq,, lane_move_cnt, participants_seq -> IFNULL 처리
        1.0.0.3		2023.07.20	이선우	participants_seq 추가
		1.0.0.2		2023.07.19	이선우	competition_seq, move_method, lane_move_cnt, handy 추가
		1.0.0.1		2023.06.21	이선우	game_min 추가
		1.0.0.0		2023.05.22	이선우	최초작성
		=================================================================

	Copyrightⓒ(주)솔비포스 2023All rights reserved.

*****/
	IN p_store_cd varchar(5)
)
BEGIN
	SELECT
		A.assign_seq
		, B.use_seq AS assign_bowler_seq
		, CONCAT(A.assign_dt, LPAD(A.assign_seq, 4, '0')) AS assign_no
		, A.assign_lane_no
		, A.lane_no
		, A.game_div
        , IFNULL(A.competition_seq, 0) AS competition_seq
		, A.league_yn
        , A.move_method
        , IFNULL(A.lane_move_cnt, 0) AS lane_move_cnt
		, A.assign_status
		, A.assign_root_div
		, A.reserve_datetime
		, A.expected_end_datetime
		, B.bowler_seq
        , IFNULL(B.participants_seq, 0) AS participants_seq
		, B.bowler_id
		, B.bowler_nm
		, B.member_no
        , B.membership_seq
        , B.membership_use_cnt
        , B.membership_use_min
		, B.game_start
		, B.game_cnt
        , B.game_min
		, B.game_fin
        , B.handy
        , B.shoes_yn
        , IFNULL(C.frame_to, 0) AS frame_no
        , IFNULL(C.game_status, 0) AS direction
		, B.product_cd
		, B.product_nm
		, B.payment_type
		, B.fee_div
		, B.use_status
		, B.receipt_no
		, A.user_id
	FROM tb_assign A
	INNER JOIN tb_assign_bowler B
	ON (
		A.store_cd = B.store_cd
		AND A.assign_dt = B.assign_dt
		AND A.assign_seq = B.assign_seq
	)
	LEFT OUTER JOIN tb_game C
	ON (
		A.store_cd = C.store_cd
		AND A.assign_dt = C.assign_dt
		AND A.assign_seq = C.assign_seq
        and B.bowler_seq = C.bowler_seq
        and A.game_seq = C.game_seq
	)
	WHERE A.store_cd = p_store_cd
    AND B.del_yn = 'N'
	AND A.assign_status BETWEEN 0 AND 5 -- 0:대기, 1:예약, 2:홀드, 3:진행, 5:종료(미결제), 6;종료(결제완료), 7:예약취소, 8:점검중
	ORDER BY A.assign_lane_no, A.assign_seq, B.bowler_seq;
	-- ORDER BY A.reserve_datetime, A.assign_seq, B.bowler_seq;
END