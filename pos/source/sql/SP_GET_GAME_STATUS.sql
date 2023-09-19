CREATE DEFINER=`bowling`@`%` PROCEDURE `SP_GET_GAME_STATUS`(
/*****

	[Project]
		bowlingpick 시스템
	[Object Name]
		SP_GET_GAME_STATUS
	[Description]
		게임 가동 상항를 조회한다.
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
        1.0.0.6     2023.08.22  이선우    t3.shoes_yn 추가
        1.0.0.5     2023.08.21  이선우    t2.user_id 추가
        1.0.0.5     2023.08.03  이선우    t3.membership_use_cnt, t3.membership_use_min 추가
        1.0.0.4     2023.07.25  이선우    t3.membership_seq 추가
        1.0.0.3     2023.07.24  이선우    t2.competition_seq -> ifnull() 처리
                                        t2.lane_move_cnt -> ifnull() 처리
                                        t3.participants_seq -> ifnull() 처리
		1.0.0.2     2023.06.21  이선우    t3.game_min 추가
		1.0.0.1     2023.05.23  이선우    t2.expected_end_datetime 추가
		                                t2.end_datetime 추가
		1.0.0.0     2023.01.17  조한용    최초작성
		=================================================================

	Copyrightⓒ(주)솔비포스 2020. All rights reserved.

*****/
	IN p_store_cd varchar(5)
)
BEGIN
	SELECT
		t1.use_seq, t1.store_cd, ifnull(t2.assign_lane_no, 0) as assign_lane_no, t1.lane_no, t1.lane_nm,
        CASE
          WHEN t1.hold_yn = 'Y' THEN 2
          WHEN t1.use_status = 8 THEN 8
		  ELSE ifnull(t2.assign_status, '0') 
		END AS lane_status, -- 0: 빈타석, 1:예약건, 2:홀드, 3:진행
		
        concat(t2.assign_dt, lpad(t2.assign_seq, 4, '0')) AS assign_no, -- 배정번호
        t2.game_div,    -- 1:게임제, 2:시간제
        t2.league_yn,    -- 리그 게임 여부
		t2.assign_root_div,  -- 배정경로
        
        ifnull(t2.competition_seq, 0) AS competition_seq, -- 대회 순번
        ifnull(t2.lane_move_cnt, 0) AS lane_move_cnt,  -- 레인이동수
        t2.move_method,  -- 이동방법
        
        t2.start_datetime, -- 배정시작시간
        t2.expected_end_datetime, -- 예상종료시각
        t2.end_datetime, -- 종료시각
        t2.user_id, -- 담당자ID
        
        ifnull(t3.participants_seq, 0) AS participants_seq,  -- 대최참가자순번
        t3.bowler_seq, t3.bowler_id, t3.bowler_nm, t3.member_no, t3.product_cd, t3.product_nm,
        t3.membership_seq, -- 회원권 구매 순번
        t3.membership_use_cnt, -- 게임제 회원권일 경우 이용 게임 수
        t3.membership_use_min, -- 시간제 회원권일 경우 이용 게임 시간
        t3.payment_type, -- 결제 0:후불, 1:선불
        t3.fee_div,  -- 01:일반, 02:회원, 03:학생, 04:클럽
		t3.game_cnt, -- 게임지정수,
		t3.game_min, -- 게임지정시간,
        t3.game_fin,  -- 게임완료수
        t3.handy,
        t3.shoes_yn, -- 볼링화 대여 여부
       
        t4.game_status, -- 현재 투구 중인 레인 방향: 0:대기, 1: 왼쪽 투 , 2: 오른쪽 투, 3: 일시정지
        t4.frame_to, -- 현재 프레임
        t4.pin_fall_result, -- 프레인 투 점수
        t4.frame1_score, t4.frame2_score, t4.frame3_score, t4.frame4_score, t4.frame5_score, 
        t4.frame6_score, t4.frame7_score, t4.frame8_score, t4.frame9_score, t4.frame10_score, 
		t4.total_score,
        t4.frame1_pin, t4.frame2_pin, t4.frame3_pin, t4.frame4_pin,	t4.frame5_pin, 
        t4.frame6_pin, t4.frame7_pin, t4.frame8_pin, t4.frame9_pin, t4.frame10_pin
	FROM tb_lane t1
    LEFT OUTER JOIN (
		SELECT
        use_seq, assign_dt, assign_seq, 
        game_seq, assign_lane_no, lane_no, game_div, game_type, league_yn, assign_status, assign_root_div,
        competition_seq, lane_move_cnt, move_method,
        start_datetime, expected_end_datetime, end_datetime, user_id
		FROM tb_assign
		WHERE store_cd = p_store_cd
        AND ((assign_status = '3') or (assign_status = '5'))
	) t2
	ON (
		t1.lane_no = t2.lane_no
	)
	LEFT OUTER JOIN (
		SELECT
        use_seq, assign_dt, assign_seq, participants_seq,
        bowler_seq, bowler_id, bowler_nm,
        member_no, membership_seq, membership_use_cnt, membership_use_min,
        product_cd, product_nm, payment_type,
        fee_div, game_cnt, game_min, game_fin, handy, shoes_yn
		FROM tb_assign_bowler
		WHERE store_cd = p_store_cd
        AND del_yn = 'N'
	) t3
	ON (
		t2.assign_dt = t3.assign_dt
        and t2.assign_seq = t3.assign_seq
	)
    LEFT OUTER JOIN (
		SELECT
        use_seq, assign_dt, assign_seq, game_seq, game_status, last_lane_no,
        bowler_seq, bowler_id, bowler_nm,
        to_cnt, frame_to, pin_fall_result,
        frame1_score, frame2_score, frame3_score, frame4_score, frame5_score,
        frame6_score, frame7_score, frame8_score, frame9_score, frame10_score, 
        total_score,
        frame1_pin, frame2_pin,	frame3_pin, frame4_pin,	frame5_pin,
        frame6_pin,	frame7_pin, frame8_pin,	frame9_pin, frame10_pin
		FROM tb_game
		WHERE store_cd = p_store_cd
        -- AND game_status <> 0
	) t4
	ON (
		t2.assign_dt = t4.assign_dt
        and t2.assign_seq = t4.assign_seq
        and t3.bowler_seq = t4.bowler_seq
        and t2.game_seq = t4.game_seq
	)
    
	WHERE t1.store_cd = p_store_cd
    order by lane_no, bowler_seq asc;
END