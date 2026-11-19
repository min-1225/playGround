-- 1. 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS carrot_market_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE carrot_market_db;

-- 2. regions 테이블 생성
CREATE TABLE regions (
    region_id BIGINT AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    neighborhood VARCHAR(50) NOT NULL,

    CONSTRAINT pk_regions
        PRIMARY KEY (region_id),

    CONSTRAINT uq_regions_location
        UNIQUE (city, neighborhood)
) ENGINE = InnoDB;

-- 3. categories 테이블 생성
CREATE TABLE categories (
    category_id BIGINT AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,

    CONSTRAINT pk_categories
        PRIMARY KEY (category_id),

    CONSTRAINT uq_categories_name
        UNIQUE (category_name)
) ENGINE = InnoDB;

-- 4. users 테이블 생성
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT,
    nickname VARCHAR(50) NOT NULL,
    profile_image_url VARCHAR(500),
    manner_temp DECIMAL(4,1)
        NOT NULL DEFAULT 36.5,
    region_id BIGINT NOT NULL,

    CONSTRAINT pk_users
        PRIMARY KEY (user_id),

    CONSTRAINT fk_users_region
        FOREIGN KEY (region_id)
        REFERENCES regions(region_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT chk_users_manner_temp
        CHECK (
            manner_temp >= 0
            AND manner_temp <= 99.9
        )
) ENGINE = InnoDB;

-- 5. posts 테이블 생성
CREATE TABLE posts (
    post_id BIGINT AUTO_INCREMENT,
    seller_id BIGINT NOT NULL,
    region_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,

    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    price INT UNSIGNED NOT NULL,

    trade_status VARCHAR(20)
        NOT NULL DEFAULT 'SELLING',

    is_direct_purchase BOOLEAN
        NOT NULL DEFAULT FALSE,

    is_negotiable BOOLEAN
        NOT NULL DEFAULT FALSE,

    created_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    last_bumped_at DATETIME NULL,

    CONSTRAINT pk_posts
        PRIMARY KEY (post_id),

    CONSTRAINT fk_posts_seller
        FOREIGN KEY (seller_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_posts_region
        FOREIGN KEY (region_id)
        REFERENCES regions(region_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_posts_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT chk_posts_trade_status
        CHECK (
            trade_status IN (
                'SELLING',
                'RESERVED',
                'SOLD'
            )
        ),

    CONSTRAINT chk_posts_bumped_at
        CHECK (
            last_bumped_at IS NULL
            OR last_bumped_at >= created_at
        )
) ENGINE = InnoDB;

-- 6. post_images 테이블 생성
CREATE TABLE post_images (
    image_id BIGINT AUTO_INCREMENT,
    post_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    image_order INT UNSIGNED NOT NULL,

    CONSTRAINT pk_post_images
        PRIMARY KEY (image_id),

    CONSTRAINT fk_post_images_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT uq_post_images_order
        UNIQUE (post_id, image_order),

    CONSTRAINT chk_post_images_order
        CHECK (image_order >= 1)
) ENGINE = InnoDB;

-- 7. post_likes 테이블 생성
CREATE TABLE post_likes (
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,

    created_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_post_likes
        PRIMARY KEY (user_id, post_id),

    CONSTRAINT fk_post_likes_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_post_likes_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- 8. post_views 테이블 생성
CREATE TABLE post_views (
    view_id BIGINT AUTO_INCREMENT,
    post_id BIGINT NOT NULL,
    viewer_id BIGINT NULL,

    viewed_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_post_views
        PRIMARY KEY (view_id),

    CONSTRAINT fk_post_views_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_post_views_viewer
        FOREIGN KEY (viewer_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- 9. chat_rooms 테이블 생성
CREATE TABLE chat_rooms (
    room_id BIGINT AUTO_INCREMENT,
    post_id BIGINT NOT NULL,
    buyer_id BIGINT NOT NULL,

    CONSTRAINT pk_chat_rooms
        PRIMARY KEY (room_id),

    CONSTRAINT fk_chat_rooms_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_chat_rooms_buyer
        FOREIGN KEY (buyer_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT uq_chat_rooms_post_buyer
        UNIQUE (post_id, buyer_id)
) ENGINE = InnoDB;

-- 10. chat_messages 테이블 생성
CREATE TABLE chat_messages (
    message_id BIGINT AUTO_INCREMENT,
    room_id BIGINT NOT NULL,
    sender_id BIGINT NOT NULL,

    message_type VARCHAR(10)
        NOT NULL DEFAULT 'TEXT',

    content TEXT NULL,

    created_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_chat_messages
        PRIMARY KEY (message_id),

    CONSTRAINT fk_chat_messages_room
        FOREIGN KEY (room_id)
        REFERENCES chat_rooms(room_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_chat_messages_sender
        FOREIGN KEY (sender_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT uq_chat_messages_room_message
        UNIQUE (room_id, message_id),

    CONSTRAINT chk_chat_messages_type
        CHECK (
            message_type IN ('TEXT', 'IMAGE')
        ),

    CONSTRAINT chk_chat_messages_content
        CHECK (
            (
                message_type = 'TEXT'
                AND content IS NOT NULL
                AND CHAR_LENGTH(content) > 0
            )
            OR
            (
                message_type = 'IMAGE'
                AND content IS NULL
            )
        )
) ENGINE = InnoDB;

-- 11. chat_message_images 테이블 생성
CREATE TABLE chat_message_images (
    image_id BIGINT AUTO_INCREMENT,
    message_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    image_order INT UNSIGNED NOT NULL,

    CONSTRAINT pk_chat_message_images
        PRIMARY KEY (image_id),

    CONSTRAINT fk_chat_message_images_message
        FOREIGN KEY (message_id)
        REFERENCES chat_messages(message_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT uq_chat_message_images_order
        UNIQUE (message_id, image_order),

    CONSTRAINT chk_chat_message_images_order
        CHECK (image_order >= 1)
) ENGINE = InnoDB;

-- 12. chat_room_reads 테이블 생성
CREATE TABLE chat_room_reads (
    room_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    last_read_message_id BIGINT NULL,

    updated_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_chat_room_reads
        PRIMARY KEY (room_id, user_id),

    CONSTRAINT fk_chat_room_reads_room
        FOREIGN KEY (room_id)
        REFERENCES chat_rooms(room_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_chat_room_reads_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_chat_room_reads_last_message
        FOREIGN KEY (
            room_id,
            last_read_message_id
        )
        REFERENCES chat_messages(
            room_id,
            message_id
        )
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- 13. message_likes 테이블 생성
CREATE TABLE message_likes (
    message_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,

    created_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_message_likes
        PRIMARY KEY (message_id, user_id),

    CONSTRAINT fk_message_likes_message
        FOREIGN KEY (message_id)
        REFERENCES chat_messages(message_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_message_likes_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- 14. 전체 외래키 확인
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'carrot_market_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME,
         ORDINAL_POSITION;
