import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final Dio client;

  ReviewsRemoteDataSourceImpl({
    required this.client,
  });

  PaginationModel? paginationModel;

  @override
  Future<Review?> deleteLoungeReview({required int? id}) async {
    final String url = API.reviews + "/" + id.toString();

    try {
      final Response? response = await client.delete(url);
      if (response?.statusCode == 200) {
        final review = ReviewModel.fromJson(response?.data);
        return review;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }

  @override
  Future<List<Review?>> getLoungeReviews({
    String? sortBy,
    required int? id,
  }) async {
    try {
      final url = API.loungeReviews + "/" + id.toString();
      final Response? response = await client.get(url, queryParameters: {
        if (StringUtils().isNotEmpty(sortBy)) "sort_by": sortBy,
      });
      if (response?.statusCode == 200) {
        paginationModel = PaginationModel?.fromJson(response?.data);
        final reviews = ReviewModel.fromJsonList(paginationModel?.items);
        return reviews;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }

  @override
  Future<List<Review?>> getMoreLoungeReviews({
    String? sortBy,
    required int? id,
  }) async {
    if (StringUtils().isNotEmpty(paginationModel?.meta.links?.next)) {
      try {
        final url = API.loungeReviews + "/" + id.toString();
        final Response? response = await client.get(url, queryParameters: {
          if (StringUtils().isNotEmpty(sortBy))
            "sort_by": sortBy!.toLowerCase(),
          "page": paginationModel!.meta.currentPage! + 1,
        });
        if (response?.statusCode == 200) {
          paginationModel = PaginationModel?.fromJson(response?.data);
          final reviews = ReviewModel.fromJsonList(paginationModel?.items);
          return reviews;
        } else {
          final serverError = ServerError.fromJson(null);
          throw ServerException(serverError);
        }
      } catch (e) {
        throw ServerException.handleError(e);
      }
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<List<Review?>> getMoreUserReviews({String? sortBy}) async {
    if (StringUtils().isNotEmpty(paginationModel?.meta.links?.next)) {
      try {
        final Response? response =
            await client.get(API.userReviews, queryParameters: {
          if (StringUtils().isNotEmpty(sortBy)) "sort_by": sortBy,
          "page": paginationModel!.meta.currentPage! + 1,
        });
        if (response?.statusCode == 200) {
          paginationModel = PaginationModel?.fromJson(response?.data);
          final reviews = ReviewModel.fromJsonList(paginationModel?.items);
          return reviews;
        } else {
          final serverError = ServerError.fromJson(null);
          throw ServerException(serverError);
        }
      } catch (e) {
        throw ServerException.handleError(e);
      }
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<List<Review?>> getUserReviews({String? sortBy}) async {
    try {
      final Response? response =
          await client.get(API.userReviews, queryParameters: {
        if (StringUtils().isNotEmpty(sortBy)) "sort_by": sortBy,
      });
      if (response?.statusCode == 200) {
        paginationModel = PaginationModel?.fromJson(response?.data);
        final reviews = ReviewModel.fromJsonList(paginationModel?.items);
        return reviews;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }

  @override
  Future<Review?> patchLoungeReview({
    int? reviewId,
    double? rating,
    String? review,
    List<int?>? deletedImages,
    List<File?>? images,
  }) async {
    List<MultipartFile?> _multipartImages = [];

    final String url = API.reviews + "/" + reviewId.toString();

    if (images != null && images.isNotEmpty) {
      for (File? image in images) {
        _multipartImages.add(MultipartFile.fromFileSync(image!.path));
      }
    }

    final body = FormData.fromMap({
      if (rating != null) 'rating': rating,
      if (StringUtils().isNotEmpty(review)) 'review': review,
      if (deletedImages != null && deletedImages.isNotEmpty)
        "deleted_images[]": deletedImages,
      if (_multipartImages.isNotEmpty) "images[]": _multipartImages,
    });

    try {
      final Response? response = await client.post(url, data: body);
      if (response?.statusCode == 200) {
        final review = ReviewModel.fromJson(response?.data);
        return review;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }

  @override
  Future<Review?> postLoungeReview({
    int? loungeId,
    double? rating,
    String? review,
    List<File?>? images,
  }) async {
    List<MultipartFile?> _multipartImages = [];

    if (images != null && images.isNotEmpty) {
      for (File? image in images) {
        _multipartImages.add(MultipartFile.fromFileSync(image!.path));
      }
    }

    final body = FormData.fromMap({
      if (loungeId != null) 'lounge_id': loungeId,
      if (rating != null) 'rating': rating,
      if (StringUtils().isNotEmpty(review)) 'review': review,
      if (_multipartImages.isNotEmpty) "images[]": _multipartImages,
    });

    try {
      final Response? response = await client.post(API.reviews, data: body);
      if (response?.statusCode == 200) {
        final review = ReviewModel.fromJson(response?.data);
        return review;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }
}
