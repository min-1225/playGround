USE carrot_market_db;

-- 1. regions 데이터 삽입
INSERT INTO regions (region_id, city, neighborhood) VALUES
    (1, '성남시 수정구', '복정동'),
    (2, '성남시 수정구', '태평동');

SELECT * FROM regions;

-- 2. categories 데이터 삽입
INSERT INTO categories (category_id, category_name) VALUES
    (1, '디지털기기'),
    (2, '가구/인테리어'),
    (3, '생활가전'),
    (4, '도서'),
    (5, '의류');

SELECT * FROM categories;

-- 3. users 데이터 삽입 (1, 2, 5 = 복정동 / 3, 4 = 태평동)
INSERT INTO users (user_id, nickname, profile_image_url, manner_temp, region_id) VALUES
    (1, '복정새내기', 'https://img.example.com/profile/1.jpg', 37.2, 1),
    (2, '가천러버',   'https://img.example.com/profile/2.jpg', 36.5, 1),
    (3, '태평동주민', 'https://img.example.com/profile/3.jpg', 38.4, 2),
    (4, '자취생살림', NULL,                                    36.5, 2),
    (5, '중고왕',     'https://img.example.com/profile/5.jpg', 41.3, 1);

SELECT * FROM users;

-- 4. posts 데이터 삽입
--   - 1번, 6번: 끌올한 글 (last_bumped_at 있음)
--   - 3번: 예약중, 4번: 거래완료
--   - 7번: 사진 없는 글
--   - 8번: 작성 후 수정한 글 (updated_at > created_at)
--   - updated_at 은 ON UPDATE CURRENT_TIMESTAMP 라서 끌올·상태 변경 시각도 반영
INSERT INTO posts (post_id, seller_id, region_id, category_id, title, content, price,
                   trade_status, is_direct_purchase, is_negotiable,
                   created_at, updated_at, last_bumped_at) VALUES
    (1, 1, 1, 1, '아이패드 9세대 64GB 와이파이',
        '작년에 산 아이패드입니다. 케이스 같이 드려요. 복정역 직거래 가능.',
        250000, 'SELLING',  TRUE,  TRUE,
        '2026-11-10 10:00:00', '2026-11-17 09:00:00', '2026-11-17 09:00:00'),
    (2, 2, 1, 4, '데이터베이스 개론 전공책',
        '필기 조금 있어요. 가천대 정문 앞 거래.',
        12000,  'SELLING',  FALSE, FALSE,
        '2026-11-16 14:00:00', '2026-11-16 14:00:00', NULL),
    (3, 5, 1, 3, '미니 냉장고 (자취방용)',
        '1년 사용, 소음 거의 없음.',
        60000,  'RESERVED', FALSE, TRUE,
        '2026-11-15 20:00:00', '2026-11-17 11:25:00', NULL),
    (4, 5, 1, 2, '원룸 책상 + 의자 세트',
        '이사로 정리합니다. 직접 가져가셔야 해요.',
        30000,  'SOLD',     FALSE, FALSE,
        '2026-11-12 11:00:00', '2026-11-17 15:20:00', NULL),
    (5, 3, 2, 5, '롱패딩 L 사이즈',
        '두 번 입었어요. 세탁 완료.',
        40000,  'SELLING',  TRUE,  FALSE,
        '2026-11-17 18:00:00', '2026-11-17 18:00:00', NULL),
    (6, 4, 2, 3, '전자레인지 20L',
        '잘 돌아갑니다. 태평역 근처.',
        25000,  'SELLING',  FALSE, TRUE,
        '2026-11-14 09:00:00', '2026-11-18 08:30:00', '2026-11-18 08:30:00'),
    (7, 3, 2, 1, '에어팟 프로 2세대',
        '사진은 채팅으로 보내드릴게요.',
        150000, 'SELLING',  FALSE, FALSE,
        '2026-11-13 13:00:00', '2026-11-13 13:00:00', NULL),
    (8, 1, 1, 4, '토익 RC 교재',
        '문제 안 풀었어요. (가격 수정함)',
        8000,   'SELLING',  FALSE, FALSE,
        '2026-11-18 07:00:00', '2026-11-18 07:30:00', NULL);

SELECT * FROM posts;

-- 5. post_images 데이터 삽입 (image_order = 1 이 대표 이미지, 7번 글은 사진 없음)
INSERT INTO post_images (post_id, image_url, image_order) VALUES
    (1, 'https://img.example.com/post/1-1.jpg', 1),
    (1, 'https://img.example.com/post/1-2.jpg', 2),
    (1, 'https://img.example.com/post/1-3.jpg', 3),
    (2, 'https://img.example.com/post/2-1.jpg', 1),
    (3, 'https://img.example.com/post/3-1.jpg', 1),
    (3, 'https://img.example.com/post/3-2.jpg', 2),
    (4, 'https://img.example.com/post/4-1.jpg', 1),
    (5, 'https://img.example.com/post/5-1.jpg', 1),
    (5, 'https://img.example.com/post/5-2.jpg', 2),
    (6, 'https://img.example.com/post/6-1.jpg', 1),
    (8, 'https://img.example.com/post/8-1.jpg', 1);

SELECT * FROM post_images;

-- 6. post_likes 데이터 삽입 (1번 글 3개, 3번 글 2개, 5번·6번 글 1개씩)
INSERT INTO post_likes (user_id, post_id, created_at) VALUES
    (2, 1, '2026-11-17 09:30:00'),
    (3, 1, '2026-11-17 11:50:00'),
    (4, 1, '2026-11-17 20:00:00'),
    (1, 3, '2026-11-16 08:00:00'),
    (2, 3, '2026-11-16 12:00:00'),
    (4, 5, '2026-11-17 19:00:00'),
    (3, 6, '2026-11-18 08:35:00');

SELECT * FROM post_likes;

-- 7. post_views 데이터 삽입 (viewer_id NULL = 비로그인 조회)
--    조회수: 1번 글 6, 3번 글 3, 5번 글 3, 6번 글 2, 2번 글 1
INSERT INTO post_views (post_id, viewer_id, viewed_at) VALUES
    (1, 2,    '2026-11-17 09:20:00'),
    (1, 2,    '2026-11-17 09:25:00'),
    (1, 3,    '2026-11-17 11:45:00'),
    (1, NULL, '2026-11-17 13:00:00'),
    (1, NULL, '2026-11-17 13:01:00'),
    (1, 1,    '2026-11-17 14:00:00'),
    (2, 5,    '2026-11-16 15:00:00'),
    (3, 1,    '2026-11-16 07:55:00'),
    (3, 2,    '2026-11-16 11:58:00'),
    (3, NULL, '2026-11-16 22:00:00'),
    (5, 4,    '2026-11-17 18:30:00'),
    (5, 4,    '2026-11-17 18:55:00'),
    (5, NULL, '2026-11-17 21:00:00'),
    (6, 3,    '2026-11-18 08:33:00'),
    (6, NULL, '2026-11-18 08:45:00');

SELECT * FROM post_views;

-- 8. chat_rooms 데이터 삽입 (판매자는 posts.seller_id 로 조회)
--    room 1: 1번 글(판매자 1) - 구매자 2
--    room 2: 1번 글(판매자 1) - 구매자 3
--    room 3: 3번 글(판매자 5) - 구매자 1  (예약중)
--    room 4: 6번 글(판매자 4) - 구매자 3
--    room 5: 4번 글(판매자 5) - 구매자 2  (거래완료)
INSERT INTO chat_rooms (room_id, post_id, buyer_id) VALUES
    (1, 1, 2),
    (2, 1, 3),
    (3, 3, 1),
    (4, 6, 3),
    (5, 4, 2);

SELECT * FROM chat_rooms;

-- 9. chat_messages 데이터 삽입 (message_id 순서 = 전송 시간 순서)
--    IMAGE 메시지는 content = NULL (chk_chat_messages_content)
INSERT INTO chat_messages (message_id, room_id, sender_id, message_type, content, created_at) VALUES
    (1,  1, 2, 'TEXT',  '안녕하세요 아이패드 아직 판매하시나요?', '2026-11-17 10:00:00'),
    (2,  1, 1, 'TEXT',  '네 판매중이에요!',                         '2026-11-17 10:05:00'),
    (3,  1, 1, 'IMAGE', NULL,                                        '2026-11-17 10:06:00'),
    (4,  1, 2, 'TEXT',  '23만원에 가능할까요?',                      '2026-11-17 10:10:00'),
    (5,  3, 1, 'TEXT',  '냉장고 예약 가능할까요?',                   '2026-11-17 11:00:00'),
    (6,  3, 5, 'TEXT',  '네 내일 저녁에 가능하세요?',                '2026-11-17 11:20:00'),
    (7,  3, 1, 'TEXT',  '네 7시에 복정역 1번 출구에서 뵐게요',       '2026-11-17 11:21:00'),
    (8,  2, 3, 'TEXT',  '태평동인데 직거래 가능하세요?',             '2026-11-17 12:00:00'),
    (9,  2, 3, 'TEXT',  '혹시 박스도 있나요?',                       '2026-11-17 12:01:00'),
    (10, 5, 2, 'TEXT',  '책상 오늘 가지러 가도 될까요?',             '2026-11-17 15:00:00'),
    (11, 5, 5, 'TEXT',  '네 감사합니다 잘 쓰세요!',                  '2026-11-17 15:10:00'),
    (12, 4, 3, 'TEXT',  '전자레인지 상태 어떤가요?',                 '2026-11-18 08:40:00'),
    (13, 4, 4, 'IMAGE', NULL,                                        '2026-11-18 08:50:00'),
    (14, 1, 1, 'TEXT',  '23만원까지는 괜찮아요',                     '2026-11-18 09:00:00');

SELECT * FROM chat_messages;

-- 10. chat_message_images 데이터 삽입 (3번 메시지 2장, 13번 메시지 1장)
INSERT INTO chat_message_images (message_id, image_url, image_order) VALUES
    (3,  'https://img.example.com/chat/3-1.jpg',  1),
    (3,  'https://img.example.com/chat/3-2.jpg',  2),
    (13, 'https://img.example.com/chat/13-1.jpg', 1);

SELECT * FROM chat_message_images;

-- 11. chat_room_reads 데이터 삽입 (방마다 판매자/구매자 2행)
--     안 읽은 메시지: user1 = 2, user2 = 1, user3 = 1, user4 = 0, user5 = 1
INSERT INTO chat_room_reads (room_id, user_id, last_read_message_id, updated_at) VALUES
    (1, 1, 4,    '2026-11-17 10:11:00'),   -- 판매자 1: 안 읽음 0
    (1, 2, 3,    '2026-11-17 10:07:00'),   -- 구매자 2: 14번 안 읽음 → 1
    (2, 1, NULL, '2026-11-17 12:00:00'),   -- 판매자 1: 한 번도 안 읽음 → 8, 9번 → 2
    (2, 3, 9,    '2026-11-17 12:01:00'),   -- 구매자 3: 안 읽음 0
    (3, 1, 7,    '2026-11-17 11:21:00'),   -- 구매자 1: 안 읽음 0
    (3, 5, 6,    '2026-11-17 11:20:00'),   -- 판매자 5: 7번 안 읽음 → 1
    (4, 3, 12,   '2026-11-18 08:40:00'),   -- 구매자 3: 13번 안 읽음 → 1
    (4, 4, 13,   '2026-11-18 08:50:00'),   -- 판매자 4: 안 읽음 0
    (5, 2, 11,   '2026-11-17 15:11:00'),   -- 구매자 2: 안 읽음 0
    (5, 5, 11,   '2026-11-17 15:10:00');   -- 판매자 5: 안 읽음 0

SELECT * FROM chat_room_reads;

-- 12. message_likes 데이터 삽입
INSERT INTO message_likes (message_id, user_id, created_at) VALUES
    (2,  2, '2026-11-17 10:06:00'),
    (6,  1, '2026-11-17 11:21:00'),
    (7,  5, '2026-11-17 11:30:00'),
    (11, 2, '2026-11-17 15:12:00');

SELECT * FROM message_likes;

-- 13. 전체 데이터 건수 확인
--     기대값: regions 2, categories 5, users 5, posts 8, post_images 11, post_likes 7,
--             post_views 15, chat_rooms 5, chat_messages 14, chat_message_images 3,
--             chat_room_reads 10, message_likes 4
SELECT 'regions'             AS table_name, COUNT(*) AS row_count FROM regions
UNION ALL SELECT 'categories',          COUNT(*) FROM categories
UNION ALL SELECT 'users',               COUNT(*) FROM users
UNION ALL SELECT 'posts',               COUNT(*) FROM posts
UNION ALL SELECT 'post_images',         COUNT(*) FROM post_images
UNION ALL SELECT 'post_likes',          COUNT(*) FROM post_likes
UNION ALL SELECT 'post_views',          COUNT(*) FROM post_views
UNION ALL SELECT 'chat_rooms',          COUNT(*) FROM chat_rooms
UNION ALL SELECT 'chat_messages',       COUNT(*) FROM chat_messages
UNION ALL SELECT 'chat_message_images', COUNT(*) FROM chat_message_images
UNION ALL SELECT 'chat_room_reads',     COUNT(*) FROM chat_room_reads
UNION ALL SELECT 'message_likes',       COUNT(*) FROM message_likes;
