const { pool } = require('../../database')

exports.index = async (page, size, keyword) => {
    if (!page || !size) {
        throw new Error("Page and size are required");
    }

    let query = `SELECT feed.*, u.name AS user_name, feed.image_id 
                 FROM feed
                 LEFT JOIN user u ON u.id = feed.user_id
                 LEFT JOIN files f ON feed.image_id = f.id`;

    const params = [];

    if (keyword) {
        query += ` WHERE LOWER(feed.title) LIKE ? OR LOWER(feed.content) LIKE ?`;
        const keywordParam = `%${keyword}%`;
        params.push(keywordParam, keywordParam);
    }

    query += ` ORDER BY feed.id DESC`;
    
    try {
        // LIMIT과 OFFSET을 제거한 쿼리 실행
        const result = await pool.query(query, params);
        return result;
    } catch (err) {
        console.error('Error executing query:', err);
        throw new Error("Error fetching feed data");
    }
}


exports.create = async (user, title, content, price, image) => {
    if (!user || !title || !content || price === undefined) {
        throw new Error("Missing required fields: user, title, content, or price");
    }

    const query = `INSERT INTO feed (user_id, title, content, price, image_id) VALUES (?,?,?,?,?)`;
    const imageId = image === undefined ? null : image; // 이미지 ID가 없으면 NULL 처리

    try {
        const result = await pool.query(query, [user, title, content, price, imageId]);
        return result;
    } catch (error) {
        console.error("Error executing query: ", error);
        throw new Error("Error creating feed");
    }
}

exports.show = async (id) => {
    if (!id) {
        throw new Error("Missing required field: id");
    }

    const query = `SELECT feed.*, u.name AS user_name, u.profile_id AS user_profile, feed.image_id
                   FROM feed
                   LEFT JOIN user u ON u.id = feed.user_id
                   LEFT JOIN files f1 ON feed.image_id = f1.id
                   LEFT JOIN files f2 ON u.profile_id = f2.id
                   WHERE feed.id = ?`;

    try {
        const result = await pool.query(query, [id]);
        return (result.length === 0) ? null : result[0]; // 결과가 없으면 null 반환
    } catch (error) {
        console.error("Error executing query: ", error);
        throw new Error("Error fetching feed data");
    }
}

exports.update = async (title, content, price, imgid, id) => {
    if (!id || !title || !content || price === undefined) {
        throw new Error("Missing required fields: title, content, price, or id");
    }

    const imageId = imgid === undefined ? null : imgid; // 이미지 ID가 없으면 NULL 처리

    const query = `UPDATE feed SET title = ?, content = ?, price = ?, image_id = ? WHERE id = ?`;

    try {
        const result = await pool.query(query, [title, content, price, imageId, id]);
        return result;
    } catch (error) {
        console.error("Error executing query: ", error);
        throw new Error("Error updating feed data");
    }
}

exports.delete = async (id) => {
    if (!id) {
        throw new Error("Missing required field: id");
    }

    const query = `DELETE FROM feed WHERE id = ?`;

    try {
        const result = await pool.query(query, [id]);
        return result;
    } catch (error) {
        console.error("Error executing query: ", error);
        throw new Error("Error deleting feed");
    }
}
